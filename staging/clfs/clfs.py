import collections
import itertools
import logging
import os
import pdb
import pprint
import struct
from errno import *

CLFS_NAMEMAX = 64

TYPE_DIRECTORY = 1
TYPE_REGULAR_FILE = 2

CLUSTER_FREE =          0
CLUSTER_END_OF_CHAIN =  0xffffffff
CLUSTER_ATAB_PADDING =  0xfffffffe

class classproperty(property):

    #def __init__(self, *propfuncs):
    #    property.__init__(self, *map(classmethod, propfuncs))

    def __get__(self, instance, owner):
        #assert instance == None, instance
        return property.__get__(self, owner)

def ClfsStructField(*args):
    a = list(args)
    if len(a) < 3:
        a.append(None)
    else:
        assert a[2] != None
    return collections.namedtuple(
            "ClfsStructField",
            ("name", "format", "initval")
        )(*a)


class ClfsStructType(type):

    # this is done in the new function so that changes to attrs
    # are made before class instantiation, and not hacked on later
    def __new__(mcs, name, bases, attrs):
        fields = ()
        # tried this using itertool chaining, blegh...
        def all_fields():
            for base in bases:
                if hasattr(base, "fields"):
                    for field in base.fields:
                        yield field
            for a in attrs["_fields_"]:
                yield ClfsStructField(*a)
        for field in all_fields():
            assert field.name not in (c.name for c in fields)
            fields += (field,)
        attrs["_ClfsStruct__fields"] = fields
        del attrs["_fields_"]
        #attrs["_fields_"] = dict(attrs["_fields_"] + bases[0]._fields_)
        return type.__new__(mcs, name, bases, attrs)

class ClfsStruct(object):

    __metaclass__ = ClfsStructType
    _fields_ = ()

    def __init__(self, **initvals):
        self.__values = {}
        for field in self.fields:
            value = initvals.pop(field.name, field.initval)
            if value is not None:
                self.__values[field.name] = value
        assert not initvals, initvals

    def __check_field(self, name):
        if name not in (a.name for a in self.fields):
            raise KeyError("{0} structure does not have field named {1!r}"
                    .format(self.__class__.__name__, name))

    def __getitem__(self, name):
        self.__check_field(name)
        assert name in self.__values, repr(name)
        return self.__values[name]

    def __setitem__(self, name, value):
        self.__check_field(name)
        self.__values[name] = value

    @classmethod
    def from_fileobj(class_, fileobj):
        return class_.unpack(fileobj.read(class_.size))

    #@classproperty
    #def __fields(self):
    #    return self.__fields
        #ClfsStructField = collections.namedtuple(
                #"ClfsStructField",
                #("name", "format", "initval"))
        #for f in self._fields_:
            #f = list(f)
            #if len(f) < 3:
                #f.append(None)
            #yield ClfsStructField(*f)

    @classmethod
    def unpack(class_, buffer):
        instance = class_()
        offset = 0
        for field in instance.fields:
            #assert field.name in instance.__values
            unpacked = struct.unpack_from(field.format, buffer, offset)
            assert len(unpacked) == 1
            instance[field.name] = unpacked[0]
            #instance.__values[field.name] = unpacked[0]
            offset += struct.calcsize(field.format)
        assert offset == len(buffer)
        return instance

    def pack(self):
        buffer = ""
        for field in self.fields:
            assert field.name in self.__values, "Field %r is uninitialized" % (field.name,)
            value = self.__values[field.name]
            try:
                buffer += struct.pack(field.format, value)
            except struct.error as exc:
                raise struct.error("Error packing %r into %s.%s, %s"
                        % (value, self.__class__.__name__, field.name, exc.message))
        assert len(buffer) == self.size
        return buffer

    @classproperty
    def fields(self):
        return self.__fields

    @classproperty
    def size(self):
        total = 0
        for field in self.fields:
            total += struct.calcsize(field.format)
        return total

    def __repr__(self):
        return "<{0} {1}>".format(self.__class__.__name__, self.__values)


class DirEntry(ClfsStruct):

    _fields_ = (
            ("name", "{0}s".format(CLFS_NAMEMAX)),
            ("inode", "I"),)

#assert DirEntry.size == 128, DirEntry.size


class Inode(ClfsStruct):

    _fields_ = (
            ("type", "B"),
            ("size", "Q"),
            ("links", "I"),)


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

    def __init__(self, path=None, fileobj=None):
        assert bool(path) ^ bool(fileobj)
        if path:
            self.f = open(path, "r+b")
        else:
            self.f = fileobj
        self.f.seek(0)
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

    def safe_seek(self, offset, whence=os.SEEK_SET):
        max_offset = self.filesystem_cluster_count * self.cluster_size
        assert max_offset <= os.fstat(self.f.fileno()).st_size, max_offset
        if whence == os.SEEK_SET:
            assert offset < max_offset
        self.f.seek(offset)
        assert self.f.tell() < max_offset

    def seek_cluster(self, cluster, offset=0):
        assert cluster < self.filesystem_cluster_count, cluster
        assert offset < self.cluster_size, offset
        byte_offset = cluster * self.cluster_size + offset
        self.safe_seek(byte_offset)

    def read_cluster(self, cluster, offset, size):
        self.seek_cluster(cluster, offset)
        assert size + offset <= self.cluster_size
        assert self.f.tell() == cluster * self.cluster_size + offset
        logging.debug("Reading %i:[%i,%i), %i bytes", cluster, offset, offset + size, size)
        return self.f.read(size)

    def write_cluster(self, cluster, offset, buffer):
        self.seek_cluster(cluster, offset)
        assert offset + len(buffer) <= self.cluster_size
        assert self.f.tell() == cluster * self.cluster_size + offset
        logging.debug("Writing %i:[%i,%i), %i bytes",
                cluster, offset, offset + len(buffer), len(buffer))
        self.f.write(buffer)
        self.f.flush()

    def next_cluster(self, clno):
        self.seek_cluster_number(clno)
        return struct.unpack("I", self.f.read(4))[0]
    next_clno = next_cluster

    def get_root_dir_entry(self):
        self.seek_cluster(0, 256)
        root_dirent = DirEntry.from_fileobj(self.f)
        assert root_dirent["name"].rstrip("\0") == "/"
        return root_dirent

    def get_inode_struct(self, inode):
        inode_struct = Inode.unpack(self.read_cluster(inode, 0, Inode.size))
        return inode_struct

    def read_directory(self, inode):
        inode_struct = self.get_inode_struct(inode)
        if inode_struct["type"] != TYPE_DIRECTORY:
            raise ClfsError(ENOTDIR)
        offset = 0
        while offset < inode_struct["size"]:
            dirent = DirEntry.unpack(self.read_inode_data(
                    inode,
                    offset,
                    DirEntry.size))
            if dirent["name"].rstrip("\0"):
                yield dirent
            offset += dirent.size

    def truncate_chain(self, clno, size):
        if clno == CLUSTER_END_OF_CHAIN:
            if size > 0:
                logging.warning("Chain ends prematurely, expected %i more bytes", size)
            return
        self.truncate_chain(self.next_clno(clno), size - self.cluster_size)
        if size <= 0:
            self.set_cluster_number(clno, CLUSTER_FREE)
        elif 0 < size <= self.cluster_size:
            self.set_cluster_number(clno, CLUSTER_END_OF_CHAIN)
        else:
            return

    def truncate_file(self, ino, size):
        inode = self.get_inode_struct(ino)
        if inode["type"] == TYPE_DIRECTORY:
            raise ClfsError(EISDIR)
        elif inode["type"] != TYPE_REGULAR_FILE:
            raise ClfsError(EINVAL)
        if size == inode["size"]:
            return
        elif size > inode["size"]:
            self.write_inode_data(ino, inode["size"], "\0" * size - inode["size"])
            del inode
        elif size < inode["size"]:
            #pdb.set_trace()
            self.truncate_chain(ino, size + inode.size)
        inode["size"] = size
        self.write_to_chain(ino, inode.size, 0, inode.pack())
        assert self.get_inode_struct(ino)["size"] == size

    def get_dir_entry(self, path):
        for name in path.split("/"):
            if not name:
                cur_dirent = self.get_root_dir_entry()
            else:
               # pdb.set_trace()
                for dirent in self.read_directory(cur_dirent["inode"]):
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

    def first_data_region_cluster_number(self):
        return self.master_region_cluster_count + self.allocation_table_cluster_count

    def valid_data_region_cluster_number(self, clno):
        return  self.first_data_region_cluster_number() \
                <= clno \
                < self.filesystem_cluster_count

    def seek_cluster_number(self, clno):
        assert self.valid_data_region_cluster_number(clno), clno
        self.safe_seek(self.cluster_size * self.master_region_cluster_count + 4 * (clno - self.first_data_region_cluster_number()))

    def set_cluster_number(self, clno, value):
        self.seek_cluster_number(clno)
        logging.debug("Setting cluster number %i->%i", clno, value)
        self.f.write(struct.pack("I", value))

    def read_from_chain(self, first_cluster, chain_size, read_offset, read_size):
        if chain_size <= 0:
            return ""
        #assert read_offset + read_size <= chain_size, (read_offset, read_size, chain_size)
        if read_offset > self.cluster_size:
            return self.read_from_chain(
                    self.next_cluster(first_cluster),
                    chain_size - self.cluster_size,
                    read_offset - self.cluster_size,
                    read_size)
        cluster_read_size = min(read_size, self.cluster_size - read_offset, chain_size)
        buffer = self.read_cluster(first_cluster, read_offset, cluster_read_size)
        assert len(buffer) == cluster_read_size
        return buffer + self.read_from_chain(
                self.next_cluster(first_cluster),
                chain_size - self.cluster_size,
                0,
                read_size - cluster_read_size)

    def write_to_chain(self, cluster, size, offset, buffer):
        """Returns (number of bytes written, the new size of the chain)"""
        assert offset >= 0, offset
        if len(buffer) == 0:
            return 0, size
        assert size >= 0, size
        assert self.valid_data_region_cluster_number(cluster), cluster
        # allocate the next cluster if we'll spill over this one
        if      self.next_clno(cluster) == CLUSTER_END_OF_CHAIN \
                and offset + len(buffer) > self.cluster_size:
            self.set_cluster_number(cluster, self.claim_free_cluster())
            #assert nextclno == self.next_cluster(cluster)
        if offset >= self.cluster_size:
            write_size, new_size = self.write_to_chain(
                    self.next_clno(cluster),
                    size - self.cluster_size,
                    offset - self.cluster_size,
                    buffer)
            return write_size, new_size + self.cluster_size
        write_size = min(len(buffer), self.cluster_size - offset)
        self.write_cluster(cluster, offset, buffer[:write_size])
        if offset + write_size > size:
            size = offset + write_size
        later_writes, new_size = self.write_to_chain(
                self.next_clno(cluster),
                size - self.cluster_size,
                0,
                buffer[write_size:])
        return write_size + later_writes, new_size + self.cluster_size

    def update_dir_entry(self, parent_dirent, update_dirent):
        assert update_dirent["name"].rstrip("\0")
        if update_dirent["name"].rstrip("\0") == "/":

            assert parent_dirent is None
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

    #def write(self, path, buf, offset):

    #def create_inode(self):
    #    pass

    def write_inode_data(self, inode, offset, buffer):
        inode_struct = self.get_inode_struct(inode)
        data_offset = inode_struct.size
        write_size, new_size = self.write_to_chain(
                inode,
                inode_struct["size"] + data_offset,
                offset + data_offset,
                buffer)
        assert write_size == len(buffer), write_size
        expected_size = data_offset + max(offset + write_size, inode_struct["size"])
        assert new_size == expected_size, (new_size, expected_size)
        #assert new_size ==
        # just update it anyway, i'll have to update times too
        inode_struct["size"] = new_size - data_offset
        #pdb.set_trace()
        assert (inode_struct.size, new_size) == self.write_to_chain(
                inode, new_size, 0, inode_struct.pack())
        assert self.get_inode_struct(inode)["size"] == new_size - data_offset
        return write_size

    def read_inode_data(self, inode, offset, size):
        inode_struct = self.get_inode_struct(inode)
        data_offset = inode_struct.size
        return self.read_from_chain(
                inode,
                inode_struct["size"] + data_offset,
                offset + data_offset,
                size)

    def create_node(self, path, type):
        #pdb.set_trace()
        node_dirname, node_basename = os.path.split(path)
        parent_dirname, parent_basename = os.path.split(node_dirname)
        parent_dirent = self.get_dir_entry(node_dirname)
        parent_inode_struct = self.get_inode_struct(parent_dirent["inode"])
        for dirent in self.read_directory(parent_dirent["inode"]):
            if dirent["name"].rstrip("\0") == node_basename:
                raise ClfsError(EEXIST)
        new_dirent = DirEntry(name=node_basename, inode=self.claim_free_cluster())
        # write the new dirent at the end of the parent directory
        assert new_dirent.size == self.write_inode_data(
                parent_dirent["inode"],
                parent_inode_struct["size"],
                new_dirent.pack(),)
        # initialize the new inode
        #pdb.set_trace()
        new_inode = Inode(type=type, size=0, links=1)
        assert (new_inode.size, new_inode.size) == self.write_to_chain(
                new_dirent["inode"], 0, 0, new_inode.pack())

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

    # write the boot record
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

    # write allocation table
    f.seek(cluster_size * master_region_cluster_count)
    for index in xrange(data_region_cluster_count):
        f.write(struct.pack("I", CLUSTER_FREE))
    for index in xrange(cluster_numbers_per_allocation_table_cluster
            - (data_region_cluster_count
                % cluster_numbers_per_allocation_table_cluster)):
        f.write(struct.pack("I", CLUSTER_ATAB_PADDING))
    assert f.tell() == cluster_size * (master_region_cluster_count + allocation_table_cluster_count)

    fs = Clfs(fileobj=f)
    del f
    rd = DirEntry(name="/", inode=fs.claim_free_cluster())
    fs.update_dir_entry(None, rd)
    rn = Inode(type=TYPE_DIRECTORY, size=0, links=0)
    fs.write_cluster(rd["inode"], 0, rn.pack())

