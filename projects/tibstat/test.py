#!/usr/bin/env python

import unittest

from dbiface import collate_stamp, to_unixepoch

class TibstatTests(unittest.TestCase):
    def test_stamp_collation(self):
        #self.assertEqual(1267111819, to_unixepoch('Fri, 26 Feb 2010 02:30:19 EST'))
        self.assertEqual(1267112159, to_unixepoch('Thu, 25 Feb 2010 15:35:59 UTC'))

if __name__ == "__main__":
    unittest.main()
