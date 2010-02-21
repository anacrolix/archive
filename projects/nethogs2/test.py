#!/usr/bin/env python

import itertools
import logging
import os
import socket
import subprocess
import timeit
import unittest

from proctab import (Connection, map_netconn_to_inode, map_sockino_to_procinfo)

class Proctab(unittest.TestCase):
    def testSocketTables(self):
        """Check that we find the same number of connections as netstat"""
        # the netstat output contains 2 header lines
        child = subprocess.Popen("netstat -tuna | wc -l", stdout=subprocess.PIPE, shell=True)
        self.assertEqual(len(map_netconn_to_inode()), int(child.communicate()[0]) - 2)
    def testTimeliness(self):
        """Mapping socket inodes to process info doesn't take too long"""
        number = 3
        dispatchInterval = 0.25
        self.assert_((number * (dispatchInterval / 5)) > timeit.timeit(
                "map_sockino_to_procinfo()",
                setup="from proctab import map_sockino_to_procinfo",
                number=number))
    def testInodeCountSanity(self):
        self.assert_(len(map_sockino_to_procinfo()) > len(map_netconn_to_inode()))
    def testMySocketAppears(self):
        udpserv = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        udpserv.bind(('', 0))
        connkey = Connection(local=udpserv.getsockname(), remote=("0.0.0.0", 0), family=udpserv.family, protocol=socket.IPPROTO_UDP)
        inode = map_netconn_to_inode()[connkey]
        procinfo = map_sockino_to_procinfo()[inode]
        self.assertEqual(os.getpid(), procinfo.pid)
        self.assertEqual(os.environ['LOGNAME'], procinfo.user)
        udpserv.close()
        self.assert_(connkey not in map_netconn_to_inode())

if __name__ == '__main__':
    unittest.main()
