#!/usr/bin/env python

import calendar, unittest

import update
from dbiface import collate_stamp, to_unixepoch

class TibstatTests(unittest.TestCase):
    def test_stamp_collation(self):
        #self.assertEqual(1267111819, to_unixepoch('Fri, 26 Feb 2010 02:30:19 EST'))
        self.assertEqual(1267112159, to_unixepoch('Thu, 25 Feb 2010 15:35:59 UTC'))
    def test_next_tibiacom_whoisonline_update(self):
        for a, b in (
                ((2038, 12, 31, 23, 56, 37), (2039, 1, 1, 0, 1, 0)),
                ((2024, 8, 15, 23, 12, 2), (2024, 8, 15, 23, 16, 0)),):
            self.assertEqual(b, update.next_tibiacom_whoisonline_update(calendar.timegm(a))[0:6])

if __name__ == "__main__":
    unittest.main()
