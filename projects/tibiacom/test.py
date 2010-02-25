#!/usr/bin/env python

import time, unittest
from source import *

class Test(unittest.TestCase):
    def test_http_compression(self):
        data = http_get(url.char_page("Eddy Aleanath"))[0]
        # check the uncompressed data is a reasonable size
        self.assert_(len(data) > 50000)
        # check that its printable data (and so likely html)
        for c in data:
            self.assert_(c in string.printable)
    def test_time_normalization(self):
        self.assertEqual(0, time.mktime(time.localtime(0)))
        for tibtime, unixtime in (
                    ("Jan 01 1970, 10:00:00 CET", 9 * 3600),
                    ("Jan 01 1970, 01:00:00 CET", 0),
                    (   time.strftime("%b %d %Y, %H:%M:%S CET", time.gmtime(int(time.time())+3600)),
                        int(time.time())),
                ):
            self.assertEqual(unixtime, parse.tibia_time_to_unix(tibtime))
        charname = "Skeletor the Vicious"
        skeletor = parse.char_page(http_get(url.char_page(charname))[0], charname)
        self.assertEqual(1064301567, parse.tibia_time_to_unix(skeletor["created"]))

if __name__ == "__main__":
    unittest.main()
