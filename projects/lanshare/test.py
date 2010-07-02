#!/usr/bin/env python

import unittest

from lanshare import *

class TestLanshareFS(unittest.TestCase):

	def test_ftp2fs(self):
		ae = self.assertEqual
		LanshareFS.shares = {
				"torrents": "/media/data/torrents",
				"tibia": "/home/matt/.tibia",
				".hgrc": ".hgrc"}
		fs = LanshareFS()
		fs.root = "/home/matt"
		f = fs.ftp2fs
		ae(f("torrents/movie.mp4"), "/media/data/torrents/movie.mp4")
		ae(f("/.hgrc"), ".hgrc")

	def test_fs2ftp(self):
		pass

class TestTypes(unittest.TestCase):

	def test_InvalidPath(self):
		self.assertRaises(TypeError, InvalidPath)

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
