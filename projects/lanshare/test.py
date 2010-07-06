#!/usr/bin/env python

import os.path
import unittest

from filesys import LanshareFS, InvalidPath

class TestLanshareFS(unittest.TestCase):

    def setUp(self):
        LanshareFS.shares = {
                "torrents": "/media/data/torrents",
                "tibia": "/home/matt/.tibia",
                ".hgrc": ".hgrc",
                "buffalo": r"E:\bah humbot",
                "python": r"\Python26",}
        fs = LanshareFS()
        self.fs = fs

    def test_homedir(self):
        self.assertRaises(AttributeError, setattr, self.fs, "root", "/home/matt")

    def test_ftp2fs(self):
        ae = self.assertEqual
        ftp2fs = self.fs.ftp2fs
        ae(ftp2fs("torrents/movie.mp4"), os.path.normpath("/media/data/torrents/movie.mp4"))
        print ftp2fs("torrents/movie.mp4")
        ae(ftp2fs("/.hgrc"), ".hgrc")

    def test_fs2ftp(self):
        self.assertEqual(self.fs.fs2ftp(r"E:\bah humbot\beast.wmv"), "/buffalo/beast.wmv")
        #self.assertEqual(self.fs.fs2ftp(r"C:\invalid file"), "/")

class TestTypes(unittest.TestCase):

    #def test_InvalidPath(self):
    #   self.assertRaises(TypeError, InvalidPath)

    pass

def main():
    suite = unittest.TestSuite()
    for case in [
                TestLanshareFS,
                TestTypes,
            ]:
        suite.addTest(unittest.makeSuite(case))
    unittest.TextTestRunner(verbosity=2).run(suite)

if __name__ == "__main__":
    main()
