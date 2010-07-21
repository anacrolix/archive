from __future__ import division

from errno import *
from stat import *
from collections import namedtuple
from os import strerror
from time import time
import logging
logger = logging.getLogger("clfs")
del logging
import os
import pdb
import pprint
import struct

CLFS_NAMEMAX = 124

#TYPE_DIRECTORY = 1
#TYPE_REGULAR_FILE = 2

ROOT_DIRENT_RAW_OFFSET = 256

clno_t = "I"

CLUSTER_VALUE_MAX = 0xffffffff
CLUSTER_FREE = 0
CLUSTER_END_OF_CHAIN = -1 & CLUSTER_VALUE_MAX
CLUSTER_ATAB_PADDING = -2 & CLUSTER_VALUE_MAX


class classproperty(property):
    """A normal property requires an instance, this one passes the owner (class) as the instance."""

    def __get__(self, instance, owner):
        return property.__get__(self, owner)


def ClfsStructField(*args):
    """Returns a named tuple used for handling of field operations"""
    a = list(args)
    if len(a) < 3:
        a.append(None)
    else:
        assert a[2] != None, "None is reserved for indicating uninitialized fields"
    return namedtuple(
            "ClfsStructField",
            ("name", "format", "initval")
        )(*a)


class ClfsStructType(type):

    # this is done in the new function so that changes to attrs
    # are made before class instantiation, and not hacked on later
    def __new__(mcs, name, bases, attrs):
        """Process _fields_ and finalize the fields attribute for the class"""
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

    __metaclass__ = ClfsStructType # for the _fields_ processing
    _fields_ = () # for issubclass based processing

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

    #def set(self, **kwargs):
        #for key, value in kwargs.iteritems():
            #self[key] = value

    @classmethod
    def from_fileobj(class_, fileobj):
        """Unpacks a new instance of this struct from a file"""
        return class_.unpack(fileobj.read(class_.size))

    @classmethod
    def unpack(class_, buffer):
        """Unpacks the buffer according to this structs format and returns a new instance"""
        instance = class_()
        offset = 0
        for field in instance.fields:
            #assert field.name in instance.__values
            unpacked = struct.unpack_from(field.format, buffer, offset)
            if len(unpacked):
                instance[field.name], = unpacked
            #instance.__values[field.name] = unpacked[0]
            offset += struct.calcsize(field.format)
        assert offset == len(buffer)
        return instance

    def pack(self):
        buffer = ""
        for field in self.fields:
            try:
                value = (self.__values[field.name],)
            except KeyError:
                value = ()
            try:
                buffer += struct.pack(field.format, *value)
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
            ("ino", "I"),)

assert DirEntry.size == 128, DirEntry.size


class Inode(ClfsStruct):

    _fields_ = (
            ("mode", "I"),
            ("__pad0", "4x"),
            ("size", "Q"),
            ("nlink", "I"),
            ("uid", "I"),
            ("gid", "I"),
            ("rdev", "Q"),
            ("atime", "I"),
            ("atimens", "I"),
            ("mtime", "I"),
            ("mtimens", "I"),
            ("ctime", "I"),
            ("ctimens", "I"),
            ("__pad1", "68x"),)

    def get_st_times(self):
        return dict((
                    ("st_" + a, self[a] + self[a + "ns"] / (10 ** 9))
                    for a in (b + "time" for b in "amc")))

    def mark_posix_change(self):
        time_parts = time_as_posix_spec()
        for time_char in "mc":
            self[time_char + "time"] = time_parts[0]
            self[time_char + "timens"] = time_parts[1]
        # remove suid and sgid bits?


assert Inode.size == 128, Inode.size


class BootRecord(ClfsStruct):

    _fields_ = (
            ("ident", "8s"),
            ("version", "I"),
            ("clrsize", "I"),
            ("mstrclrs", "I"),
            ("atabclrs", "I"),
            ("dataclrs", "I"),
            ("__pad0", "228x"),
        )

assert BootRecord.size == 256


class ClfsError(OSError):

    def __init__(self, errno):
        OSError.__init__(self, errno, strerror(errno))


def time_as_posix_spec(time):
    return int(time), int((time % 1) * (10 ** 9))


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

    # --- geometry

    @property
    def filesystem_cluster_count(self):
        return  self.master_region_cluster_count + \
                self.allocation_table_cluster_count + \
                self.data_region_cluster_count

    @property
    def clno_count_per_atab_cluster(self):
        return self.cluster_size // struct.calcsize(clno_t)

    # --- device functions

    def safe_seek(self, offset, whence=os.SEEK_SET):
        max_offset = self.filesystem_cluster_count * self.cluster_size
        assert max_offset <= os.fstat(self.f.fileno()).st_size, max_offset
        if whence == os.SEEK_SET:
            assert offset < max_offset
        self.f.seek(offset)
        assert self.f.tell() < max_offset

    def seek_root_dirent(self):
        self.seek_cluster(0, ROOT_DIRENT_RAW_OFFSET)

    # --- cluster functions

    def seek_cluster(self, cluster, offset=0):
        assert cluster < self.filesystem_cluster_count, cluster
        assert offset < self.cluster_size, offset
        byte_offset = cluster * self.cluster_size + offset
        self.safe_seek(byte_offset)

    def read_cluster(self, cluster, offset, size):
        self.seek_cluster(cluster, offset)
        assert size + offset <= self.cluster_size
        assert self.f.tell() == cluster * self.cluster_size + offset
        logger.debug("Reading %i:[%i,%i), %i bytes", cluster, offset, offset + size, size)
        return self.f.read(size)

    def write_cluster(self, cluster, offset, buffer):
        self.seek_cluster(cluster, offset)
        assert offset + len(buffer) <= self.cluster_size
        assert self.f.tell() == cluster * self.cluster_size + offset
        logger.debug("Writing %i:[%i,%i), %i bytes",
                cluster, offset, offset + len(buffer), len(buffer))
        self.f.write(buffer)
        self.f.flush()

    # --- allocation table functions

    @property
    def first_data_region_cluster_number(self):
        return  self.master_region_cluster_count + \
                self.allocation_table_cluster_count

    def valid_data_region_cluster_number(self, clno):
        return  self.first_data_region_cluster_number \
                <= clno \
                < self.filesystem_cluster_count

    def clno_get_next(self, clno):
        self.seek_cluster_number(clno)
        return struct.unpack("I", self.f.read(4))[0]
    next_clno = clno_get_next
    next_cluster = clno_get_next

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

    def seek_cluster_number(self, clno):
        assert self.valid_data_region_cluster_number(clno), clno
        self.safe_seek(self.cluster_size * self.master_region_cluster_count + 4 * (clno - self.first_data_region_cluster_number))

    def clno_set_next(self, clno, next):
        self.seek_cluster_number(clno)
        logger.debug("Setting cluster number %i->%i", clno, next)
        self.f.write(struct.pack("I", next))
    set_cluster_number = clno_set_next

    def clear_atab(self):
        self.seek_cluster(self.master_region_cluster_count)
        # set all clnos as free
        for index in xrange(self.data_region_cluster_count):
            self.f.write(struct.pack(clno_t, CLUSTER_FREE))
        # set the overhang as padding
        for index in xrange(self.clno_count_per_atab_cluster - (self.data_region_cluster_count % self.clno_count_per_atab_cluster)):
            self.f.write(struct.pack(clno_t, CLUSTER_ATAB_PADDING))
        assert self.f.tell() == self.cluster_size * (
            self.master_region_cluster_count + self.allocation_table_cluster_count)

    def dirent_remove(self, ino, offset):
        inode = self.inode_read(ino)
        dirent = DirEntry(name="", ino=CLUSTER_FREE)
        self.node_data_write(ino, offset, dirent.pack())
        inode["nlink"] -= 1
        inode.mark_posix_update()
        self.inode_write(ino, inode)

    def dirent_root(self):
        self.seek_cluster(0, 256)
        root_dirent = DirEntry.from_fileobj(self.f)
        assert root_dirent["name"].rstrip("\0") == "/"
        return root_dirent
    get_root_dir_entry = dirent_root

    def inode_read(self, ino):
        return Inode.unpack(self.read_cluster(ino, 0, Inode.size))
    get_inode_struct = inode_read

    def read_directory(self, inode):
        inode_struct = self.get_inode_struct(inode)
        if not S_ISDIR(inode_struct["mode"]):
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

    def chain_shorten(self, clno, size):
        while True:
            next = self.clno_get_next(clno)
            if next is CLUSTER_FREE:
                logger.error("Chain contains unallocated cluster %i", clno)
            if size > self.cluster_size:
                if next is CLUSTER_END_OF_CHAIN:
                    logger.error("Chain ends prematurely, expected %i more bytes", size)
                    break
            elif 0 < size <= self.cluster_size:
                self.clno_set_next(clno, CLUSTER_END_OF_CHAIN)
                logger.debug("Marking cluster %i as end of chain", clno)
            elif next is not CLUSTER_FREE:
                self.clno_set_next(clno, CLUSTER_FREE)
                logger.debug("Freeing cluster %i", clno)
            if next in (CLUSTER_FREE, CLUSTER_END_OF_CHAIN):
                break
            clno = next
            size -= self.cluster_size

    def node_data_truncate(self, ino, size):
        inode = self.inode_read(ino)
        if S_ISDIR(inode["mode"]):
            raise ClfsError(EISDIR)
        else: # what about non regular file types?
            pass
        if size == inode["size"]:
            return
        elif size > inode["size"]:
            self.node_data_write(ino, inode["size"], "\0" * (size - inode["size"]))
        elif size < inode["size"]:
            self.chain_shorten(ino, size + inode.size)
        inode["size"] = size
        self.inode_write(ino, inode)
        assert self.inode_read(ino)["size"] == size
    truncate_file = node_data_truncate

    def os_chmod(self, path, mode):
        logger.debug("os_chmod(%r, %o)", path, mode)
        ino = self.ino_from_path(path)
        inode = self.inode_read(ino)
        assert S_IFMT(mode) == S_IFMT(inode["mode"]), mode
        inode["mode"] = mode
        self.inode_write(ino, inode)

    def os_chown(self, path, uid, gid):
        ino = self.ino_from_path(path)
        inode = self.inode_read(ino)
        inode["uid"] = uid
        inode["gid"] = gid
        self.inode_write(ino, inode)

    def os_rmdir(self, path):
        dirpath, name = os.path.split(path)
        dirino = self.ino_from_path(dirpath)
        offset, dirent = self._scandir(dirino, name)
        self._rmdir(dirent["ino"])
        self.dirent_remove(dirino, offset)

    def os_truncate(self, path, size):
        self.node_data_truncate(self.ino_from_path(path), size)

    def os_unlink(self, path):
        dirpath, name = os.path.split(path)
        dirino = self.ino_from_path(dirpath)
        offset, dirent = self._scandir(dirino, name)
        self._unlink(dirent["ino"])
        self.dirent_remove(dirino, offset)

    def _rmdir(self, ino):
        inode = self.inode_read(ino)
        if not S_ISDIR(inode["mode"]):
            raise ClfsError(ENOTDIR)
        if inode["nlink"] > 2:
            raise ClfsError(ENOTEMPTY)
        if inode["nlink"] < 2:
            logger.error(
                    "Directory inode %i has invalid link count %i",
                    ino, inode["nlink"])
        self.chain_shorten(ino, 0)

    def _unlink(self, ino):
        inode = self.inode_read(ino)
        inode["nlink"] -= 1
        if inode["nlink"] > 0:
            return
        if inode["nlink"] < 0:
            logger.error("Inode %i has %i links", inode["nlink"])
        self.chain_shorten(ino, 0)
        assert self.clno_get_next(ino) == CLUSTER_FREE

    def _scandir(self, ino, name):
        for offset, dirent in self._readdir(ino):
            if dirent["name"].rstrip("\0") == name:
                return offset, dirent
        else:
            raise ClfsError(ENOENT)

    def _readdir(self, ino):
        inode = self.inode_read(ino)
        if not S_ISDIR(inode["mode"]):
            raise ClfsError(ENOTDIR)
        offset = 0
        while offset < inode["size"]:
            dirent = DirEntry.unpack(self.node_data_read(
                    ino,
                    offset,
                    DirEntry.size))
            if dirent["name"].rstrip("\0"):
                yield offset, dirent
            offset += dirent.size

    #def dir_find_name(self, ino, name):


    def dirent_from_path(self, path):
        for name in path.split("/"):
            if not name:
                cur_dirent = self.dirent_root()
            else:
                for dirent in self.read_directory(cur_dirent["ino"]):
                    if dirent["name"].rstrip("\0") == name:
                        cur_dirent = dirent
                        break
                else:
                    raise ClfsError(ENOENT)
        return cur_dirent
    get_dir_entry = dirent_from_path
    dirent_for_path = get_dir_entry

    def ino_from_path(self, path):
        return self.dirent_from_path(path)["ino"]

    def read_from_chain(self, first_cluster, chain_size, read_offset, read_size):
        if chain_size <= 0:
            return ""
        #assert read_offset + read_size <= chain_size, (read_offset, read_size, chain_size)
        if read_offset >= self.cluster_size:
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

    def node_data_write(self, ino, offset, buffer):
        inode_struct = self.get_inode_struct(ino)
        data_offset = inode_struct.size
        write_size, new_size = self.write_to_chain(
                ino,
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
                ino, new_size, 0, inode_struct.pack())
        assert self.get_inode_struct(ino)["size"] == new_size - data_offset
        return write_size
    write_inode_data = node_data_write

    def node_data_read(self, inode, offset, size):
        inode_struct = self.get_inode_struct(inode)
        data_offset = inode_struct.size
        return self.read_from_chain(
                inode,
                inode_struct["size"] + data_offset,
                offset + data_offset,
                size)
    read_node_data = node_data_read
    read_inode_data = read_node_data

    #def create_root_directory

    def inode_write(self, ino, inode):
        assert (inode.size, inode.size) == self.write_to_chain(
                cluster=ino,
                size=0,
                offset=0,
                buffer=inode.pack())

    def node_touch(self, ino, times):
        inode = self.get_inode_struct(ino)
        inode["atime"], inode["atimens"] = time_as_posix_spec(times[0])
        inode["mtime"], inode["mtimens"] = time_as_posix_spec(times[1])
        self.inode_write(ino, inode)

    def node_create(self, path, mode, uid, gid, rdev=0):
        """Create an allocate a new inode, update relevant structures elsewhere"""

        node_dirname, node_basename = os.path.split(path)
        parent_dirname, parent_basename = os.path.split(node_dirname)

        create_rootdir = bool(
                (not node_basename) and
                (node_dirname == parent_dirname == "/"))
        if create_rootdir:
            assert S_ISDIR(mode)

        new_inode = Inode(size=0, uid=uid, gid=gid, rdev=rdev, mode=mode)
        sec, nsec = time_as_posix_spec(time())
        for field_name in ("atime", "mtime", "ctime"):
            new_inode[field_name] = sec
        for field_name in ("atimens", "mtimens", "ctimens"):
            new_inode[field_name] = nsec
        del sec, nsec
        if S_ISDIR(mode):
            new_inode["nlink"] = 2
        else:
            new_inode["nlink"] = 1

        new_dirent = DirEntry(ino=self.claim_free_cluster())
        if create_rootdir:
            new_dirent["name"] = "/"
            assert new_dirent["ino"] == self.first_data_region_cluster_number, new_dirent["ino"]
        else:
            parent_ino = self.dirent_for_path(node_dirname)["ino"]
            for sibling_dirent in self.read_directory(parent_ino):
                if sibling_dirent["name"] == node_basename:
                    raise ClfsError(EEXIST)
            else:
                new_dirent["name"] = node_basename

        # write inode
        assert (new_inode.size, new_inode.size) == self.write_to_chain(
                cluster=new_dirent["ino"],
                size=0,
                offset=0,
                buffer=new_inode.pack())

        # write the new dirent at the end of the parent directory
        if create_rootdir:
            self.seek_root_dirent()
            self.f.write(new_dirent.pack())
        else:
            assert new_dirent.size == self.write_inode_data(
                    ino=parent_ino,
                    offset=self.get_inode_struct(parent_ino)["size"], # at the end
                    buffer=new_dirent.pack(),)
    create_node = node_create

def generate_bootrecord(device_size):
    # some basic geometry
    cluster_size = 512
    cluster_number_bits = 8 * struct.calcsize(clno_t)
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

    br = BootRecord()
    br["clrsize"] = cluster_size
    br["mstrclrs"] = master_region_cluster_count
    br["atabclrs"] = allocation_table_cluster_count
    br["dataclrs"] = data_region_cluster_count
    br["ident"] = "clfs"
    br["version"] = 1
    return br

def create_filesystem(path):
    # create and write boot record
    f = open(path, "r+b")
    br = generate_bootrecord(os.fstat(f.fileno()).st_size)
    f.seek(0)
    assert br.size <= 256
    f.write(br.pack())
    f.close()

    fs = Clfs(path)
    fs.clear_atab()
    fs.create_node(path="/", mode=S_IFDIR|0777, uid=0, gid=0)
