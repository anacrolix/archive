import collections
import os
import pdb
import struct
from errno import *

TYPE_DIRECTORY = 1
TYPE_REGULAR_FILE = 2

CLUSTER_FREE = 0
CLUSTER_END_OF_CHAIN = 0xffffffff


class classproperty(property):

    #def __init__(self, *propfuncs):
    #    property.__init__(self, *map(classmethod, propfuncs))

    def __get__(self, instance, owner):
        #assert instance == None, instance
        return property.__get__(self, owner)


class ClfsStruct(object):

    def __init__(self, **initvals):
        self.__values = {}
        for field in self._fields_:
            name = field[0]
            assert name not in self.__values
            format = field[1]
            initval = initvals.pop(name, field[2] if len(field) > 2 else None)
            #if len(field) > 2:
                #initval = field[2]
            #else:
                #initval = None
            self.__values[name] = initval
        assert not initvals, initvals

    def __getitem__(self, name):
        return self.__values[name]

    def __setitem__(self, name, value):
        assert name in self.__values, name
        self.__values[name] = value

    @classmethod
    def from_fileobj(class_, fileobj):
        return class_.unpack(fileobj.read(class_.size))

    @classproperty
    def fields(self):
        ClfsStructField = collections.namedtuple(
                "ClfsStructField",
                ("name", "format", "initval"))
        for f in self._fields_:
            f = list(f)
            if len(f) < 3:
                f.append(None)
            yield ClfsStructField(*f)

    @classmethod
    def unpack(class_, buffer):
        instance = class_()
        offset = 0
        for field in instance.fields:
            assert field.name in instance.__values
            unpacked = struct.unpack_from(field.format, buffer, offset)
            assert len(unpacked) == 1
            instance.__values[field.name] = unpacked[0]
            offset += struct.calcsize(field.format)
        assert offset == len(buffer)
        return instance

    def pack(self):
        buffer = ""
        for field in self.fields:
            buffer += struct.pack(field.format, self.__values[field.name])
        assert len(buffer) == self.size
        return buffer

    @classproperty
    def size(self):
        total = 0
        for field in self.fields:
            total += struct.calcsize(field.format)
        return total


class DirEntry(ClfsStruct):

    _fields_ = (
            ("name", "111s"),
            ("type", "B"),
            ("flags", "I"),
            ("cluster", "I"),
            #("parent_cluster", "I"),
            ("size", "Q"),)

assert DirEntry.size == 128, DirEntry.size


class BootRecord(ClfsStruct):

    _fields_ = (
            ("ident", "8s"),
            ("version", "I"),
            ("clrsize", "I"),
            ("mstrclrs", "I"),
            ("atabclrs", "I"),
            ("dataclrs", "I"),)

assert BootRecord.size <= 256


class ClfsError(Exception):

    def __init__(self, errno):
        self.errno = errno


class Clfs(object):

    def __init__(self, path):
        self.f = open(path, "r+b")
        br = BootRecord.from_fileobj(self.f)
        assert br["ident"].rstrip("\0") == "clfs", repr(br["ident"])
        assert br["version"] == 1
        self.cluster_size = br["clrsize"]
        self.master_region_cluster_count = br["mstrclrs"]
        self.allocation_table_cluster_count = br["atabclrs"]
        self.data_region_cluster_count = br["dataclrs"]
        self.filesystem_cluster_count = \
                self.master_region_cluster_count + \
                self.allocation_table_cluster_count + \
                self.data_region_cluster_count

    def seek_cluster(self, cluster, offset=0):
        assert cluster < self.filesystem_cluster_count, cluster
        assert offset < self.cluster_size, offset
        byte_offset = cluster * self.cluster_size + offset
        assert byte_offset < os.fstat(self.f.fileno()).st_size, byte_offset
        self.f.seek(byte_offset)

    def read_cluster(self, cluster, offset, size):
        self.seek_cluster(cluster, offset)
        assert size + offset <= self.cluster_size
        return self.f.read(size)

    def write_cluster(self, cluster, offset, buffer):
        self.seek_cluster(cluster, offset)
        assert offset + len(buffer) <= self.cluster_size
        self.f.write(buffer)

    def next_cluster(self, cluster):
        if cluster == CLUSTER_END_OF_CHAIN:
            return None
        assert cluster < self.filesystem_cluster_count, cluster

    def get_root_dir_entry(self):
        self.seek_cluster(0, 256)
        return DirEntry.from_fileobj(self.f)

    def read_directory(self, parent_dirent):
        if parent_dirent["type"] != TYPE_DIRECTORY:
            raise ClfsError(ENOTDIR)
        if parent_dirent["cluster"] != CLUSTER_END_OF_CHAIN:
            assert parent_dirent["cluster"] >= \
                self.master_region_cluster_count + self.allocation_table_cluster_count
            assert parent_dirent["cluster"] < self.filesystem_cluster_count
        offset = 0
        while offset < parent_dirent["size"]:
            dirent = DirEntry.unpack(self.read_from_chain(
                    parent_dirent["cluster"],
                    parent_dirent["size"],
                    offset,
                    DirEntry.size))
            if dirent["name"].rstrip("\0"):
                yield dirent
            offset += dirent.size

    def get_dir_entry(self, path):
        for name in path.split("/"):
            if not name:
                cur_dirent = self.get_root_dir_entry()
            else:
                for dirent in self.read_directory(cur_dirent):
                    if dirent["name"].rstrip("\0") == name:
                        cur_dirent = dirent
                        break
                else:
                    raise ClfsError(ENOENT)
        return cur_dirent

    def iter_allocation_table(self):
        self.seek_cluster(self.master_region_cluster_count)
        for index in xrange(self.data_region_cluster_count):
            yield struct.unpack("I", self.f.read(4))[0]

    def claim_free_cluster(self):
        self.seek_cluster(self.master_region_cluster_count)
        for index in xrange(self.data_region_cluster_count):
            cluster = struct.unpack("I", self.f.read(4))[0]
            if cluster == CLUSTER_FREE:
                self.f.seek(-4, os.SEEK_CUR)
                self.f.write(struct.pack("I", CLUSTER_END_OF_CHAIN))
                return index + self.master_region_cluster_count + self.allocation_table_cluster_count
        else:
            assert False, "Filesystem is full?"

    def read_from_chain(self, first_cluster, chain_size, read_offset, read_size):
        if chain_size <= 0:
            return ""
        assert read_offset + read_size <= chain_size, (read_offset, read_size, chain_size)
        if read_offset > self.cluster_size:
            return self.read_from_chain(
                    self.next_cluster(first_cluster),
                    chain_size - self.cluster_size,
                    read_offset - self.cluster_size,
                    read_size)
        cluster_read_size = min(read_size, self.cluster_size - read_offset)
        buffer = self.read_cluster(first_cluster, read_offset, cluster_read_size)
        assert len(buffer) == cluster_read_size
        return buffer + self.read_from_chain(
                self.next_cluster(first_cluster),
                chain_size - self.cluster_size,
                0,
                read_size - cluster_read_size)

    def write_to_chain(self, cluster, size, offset, buffer):
        if len(buffer) == 0:
            return 0, size
        if offset >= self.cluster_size:
            write_size, new_size = self.write_to_chain(
                    self.next_cluster(cluster),
                    size - self.cluster_size,
                    offset - self.cluster_size,
                    buffer)
            return write_size, new_size + self.cluster_size
        write_size = min(len(buffer), self.cluster_size - offset)
        self.write_cluster(cluster, offset, buffer[:write_size])
        if offset + write_size > size:
            size = offset + write_size
        later_writes, new_size = self.write_to_chain(
                self.next_cluster(cluster),
                size - self.cluster_size,
                0,
                buffer[write_size:])
        return write_size + later_writes, new_size + self.cluster_size

    def update_dir_entry(self, parent_dirent, update_dirent):
        assert update_dirent["name"].rstrip("\0")
        if update_dirent["name"].rstrip("\0") == "/":
            assert parent_dirent["name"].rstrip("\0") == "/"
            self.write_cluster(0, 256, update_dirent.pack())
            return True
        offset = 0
        while offset < parent_dirent["size"]:
            dirent = DirEntry.unpack(self.read_from_chain(
                    parent_dirent["cluster"],
                    parent_dirent["size"],
                    offset,
                    DirEntry.size))
            if dirent["name"].rstrip("\0") == update_dirent["name"].rstrip("\0"):
                write_size, new_size = self.write_to_chain(
                        parent_dirent["cluster"],
                        parent_dirent["size"],
                        offset,
                        update_dirent.pack())
                assert write_size == update_dirent.size
                assert new_size == parent_dirent["size"]
                return True
            offset += update_dirent.size
        assert offset == parent_dirent["size"]

    def create_node(self, path, type):
        node_dirname, node_basename = os.path.split(path)
        parent_dirname, parent_basename = os.path.split(node_dirname)
        parent_dirent = self.get_dir_entry(node_dirname)
        if parent_dirent["type"] != TYPE_DIRECTORY:
            raise ClfsError(ENOTDIR)
        for dirent in self.read_directory(parent_dirent):
            if dirent["name"].rstrip("\0") == node_basename:
                raise ClfsError(EEXIST)
        if parent_dirent["size"] == 0:
            assert parent_dirent["cluster"] == CLUSTER_END_OF_CHAIN
            parent_dirent["cluster"] = self.claim_free_cluster()
        new_dirent = DirEntry(
                name=node_basename, type=type, size=0, cluster=CLUSTER_END_OF_CHAIN, flags=0)
        write_size, new_size = self.write_to_chain(
                parent_dirent["cluster"],
                parent_dirent["size"],
                parent_dirent["size"],
                new_dirent.pack(),)
        #pdb.set_trace()
        assert write_size == new_dirent.size
        assert new_size == parent_dirent["size"] + DirEntry.size
        parent_dirent["size"] = new_size
        grandparent_dirent = self.get_dir_entry(parent_dirname)
        self.update_dir_entry(grandparent_dirent, parent_dirent)

def create_filesystem(device_path):
    device_file = open(device_path, "r+b")
    device_size = os.fstat(device_file.fileno()).st_size

    # some basic geometry
    cluster_size = 512
    cluster_number_bits = 32
    device_cluster_count = device_size // cluster_size

    # determine region allocations
    master_region_cluster_count = 1
    allocation_table_cluster_count = 0
    data_region_cluster_count = 0
    unallocated_cluster_count = device_cluster_count - master_region_cluster_count
    assert unallocated_cluster_count >= 0, "No space for master region"
    cluster_numbers_per_allocation_table_cluster = \
        (cluster_size * 8) // cluster_number_bits
    print "clusters per allocation table cluster", \
        cluster_numbers_per_allocation_table_cluster
    while unallocated_cluster_count > 0:
        allocation_table_cluster_count += 1
        unallocated_cluster_count -= 1
        assigned_cluster_number_count = min(
                cluster_numbers_per_allocation_table_cluster,
                unallocated_cluster_count)
        data_region_cluster_count += assigned_cluster_number_count
        unallocated_cluster_count -= assigned_cluster_number_count
    del assigned_cluster_number_count
    del unallocated_cluster_count

    # report some of the decisions made
    filesystem_cluster_count = \
            master_region_cluster_count + \
            allocation_table_cluster_count + \
            data_region_cluster_count
    print "master region cluster count", master_region_cluster_count
    print "allocation table cluster count", allocation_table_cluster_count
    print "data region cluster count", data_region_cluster_count
    assert filesystem_cluster_count == device_cluster_count, \
        (filesystem_cluster_count, device_cluster_count)

    # write the master region
    f = device_file
    f.seek(0)
    br = BootRecord()
    br["clrsize"] = cluster_size
    br["mstrclrs"] = master_region_cluster_count
    br["atabclrs"] = allocation_table_cluster_count
    br["dataclrs"] = data_region_cluster_count
    br["ident"] = "clfs"
    br["version"] = 1
    assert br.size <= 256
    f.write(br.pack())
    rd = DirEntry()
    rd["name"] = "/"
    rd["type"] = TYPE_DIRECTORY
    rd["cluster"] = CLUSTER_END_OF_CHAIN
    #rd["parent_cluster"] = CLUSTER_FREE
    rd["size"] = 0
    rd["flags"] = 0
    f.seek(256)
    f.write(rd.pack())

    # write allocation table
    for allocation_table_cluster_index in xrange(allocation_table_cluster_count):
        f.seek(cluster_size * (
                master_region_cluster_count + allocation_table_cluster_index))
        f.write(cluster_size * "\0")
