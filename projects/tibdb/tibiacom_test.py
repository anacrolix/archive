#!/usr/bin/env python3

import pdb, pprint, time, unittest
from tibiacom import char_info, tibia_time_to_unix, parse_deaths

class TibiaTime(unittest.TestCase):
    def runTest(self):
        self.assertEqual(0, time.mktime(time.localtime(0)))
        for tibtime, unixtime in (
                    ("Jan 01 1970, 10:00:00 CET", 9 * 3600),
                    ("Jan 01 1970, 01:00:00 CET", 0),
                    (   time.strftime("%b %d %Y, %H:%M:%S CET", time.gmtime(int(time.time()+3600))),
                        int(time.time())),
                ):
            self.assertEqual(unixtime, tibia_time_to_unix(tibtime))
        skeletor = char_info("Skeletor the Vicious")
        self.assertEqual(1064301567, tibia_time_to_unix(skeletor["created"]))

class Deaths(unittest.TestCase):
    def runTest(self):
        html = open("edkeys.html").read()
        pprint.pprint(parse_deaths(html))

if __name__ == '__main__':
    unittest.main()
