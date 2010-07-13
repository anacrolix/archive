import os
import struct

CLFS_DIRECTORY = 1 << 0

def format_clusterfs(device_path):
    device_file = open(device_path, "r+b")
    device_size = os.fstat(device_file.fileno()).st_size
    logical_sector_size = 512
    cluster_number_size = 4
    device_sector_count = device_size // logical_sector_size
    master_region_sector_count = 1
    allocation_table_sector_count = 0
    data_region_sector_count = 0
    unallocated_sector_count = device_sector_count - master_region_sector_count
    assert unallocated_sector_count >= 0, "No space for master region"
    while unallocated_sector_count > 0:
        allocation_table_sector_count += 1
        unallocated_sector_count -= 1
        a = logical_sector_size // cluster_number_size
        data_region_sector_count += min(a, unallocated_sector_count)
        unallocated_sector_count -= a
    del a
    del unallocated_sector_count
    filesystem_sector_count = \
            master_region_sector_count + \
            allocation_table_sector_count + \
            data_region_sector_count
    assert filesystem_sector_count == device_sector_count, \
        (filesystem_sector_count, device_sector_count)
    
    # write the master region
    f = device_file
    f.seek(0)
    f.write("\0" * logical_sector_size)
    f.seek(0)
    f.write(struct.pack("<8s4I", "clfs", 1, master_region_sector_count, allocation_table_sector_count, data_region_sector_count))
    assert f.tell() == 24, f.tell()
    f.seek(0x80)
    # name, flags, cluster, size
    f.write(struct.pack("<128sIIQ", "", CLFS_DIRECTORY, -1, 0))
    
    # write allocation table
    f.seek(512)
    for allocation_table_sector_number in xrange(allocation_table_sector_count):
        f.seek(512 + 512 * allocation_table_sector_number)
        f.write(512 * "\0")
