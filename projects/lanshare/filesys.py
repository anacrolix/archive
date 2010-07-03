from pyftpdlib.ftpserver import AbstractedFS, log

class InvalidPath(object):
	pass

class ShareRoot(object):
	pass

class LanshareFS(AbstractedFS):

	shares = None # set this

	def __init__(self):
		AbstractedFS.__init__(self)
		# need to destroy root somehow, it's not used in this FS

	def __log_original(self, before, after):
		import inspect
		log("%s.%s: %r->%r" % (
				"ftpserver.AbstractedFS", inspect.stack()[1][3], before, after))

	def __log_override(self, before, after):
		import inspect
		log("%s.%s: %r->%r" % ("LanshareFS", inspect.stack()[1][3], before, after))

	def ftp2fs(self, ftppath):
		#pdb.set_trace()
		#before = ftppath
		import os.path
		fullftp = self.ftpnorm(ftppath)
		assert fullftp[0] == "/"
		dirparts = fullftp.split("/")
		assert not dirparts[0]
		virtdir = dirparts[1]
		if not virtdir:
			return ShareRoot
		try:
			shrroot = self.shares[dirparts[1]]
		except KeyError:
			return InvalidPath
		relvirt = "/".join(dirparts[2:])
		if relvirt:
			after = os.path.join(shrroot, relvirt)
		else:
			after = shrroot
		return after

	def fs2ftp(self, fspath):
		#pdb.set_trace()
		import os.path
		if fspath in (InvalidPath, ShareRoot):
			return "/"
		oldroot = self.root
		try:
			ftppath = AbstractedFS.fs2ftp(self, fspath)
			for virtdir, shrroot in self.shares.iteritems():
				if ftppath.startswith(shrroot):
					relvirt = ftppath[len(shrroot):]
					relvirt = relvirt.lstrip("/")
					ftppath = os.path.join(virtdir, relvirt)
					if not ftppath.startswith("/"):
						ftppath = "/" + ftppath
					return ftppath
			else:
				return fspath
		finally:
			self.root = oldroot

	def validpath(self, path):
		#pdb.set_trace()
		if path is ShareRoot:
			return True
		if path is InvalidPath:
			return False
		oldroot = self.root
		try:
			for shrpath in self.shares.values():
				self.root = shrpath
				if AbstractedFS.validpath(self, path):
					valid = True
					break
			else:
				valid = False
		finally:
			self.root = oldroot
		return valid

	def realpath(self, path):
		#if path is ShareRoot:
		#	return True
		#else:
		if path in (ShareRoot, InvalidPath):
			return path
		else:
			return AbstractedFS.realpath(self, path)

	def isfile(self, path):
		#pdb.set_trace()
		if path is ShareRoot:
			return False
		else:
			return AbstractedFS.isfile(self, path)

	def open(self, filename, mode):
		from errno import EISDIR
		from os import strerror
		if filename is ShareRoot:
			raise IOError(EISDIR, strerror(EISDIR))
		else:
			return AbstractedFS.open(self, filename, mode)

	def chdir(self, path):
		if path is ShareRoot:
			self.cwd = "/"
			return
		else:
			return AbstractedFS.chdir(self, path)

	def isdir(self, path):
		if path is ShareRoot:
			return True
		else:
			return AbstractedFS.isdir(self, path)

	def listdir(self, path):
		if path is ShareRoot:
			return self.shares.keys()
		else:
			return AbstractedFS.listdir(self, path)

	def joinpath(self, head, tail):
		if head is ShareRoot:
			return self.shares[tail]
		else:
			return AbstractedFS.joinpath(self, head, tail)
