import pdb

from pyftpdlib.ftpserver import AbstractedFS, log, InvalidPath

class ShareRoot(object):
	pass

class LanshareFS(AbstractedFS):

	__slots__ = []

	shares = None # set this

	def __init__(self):
		AbstractedFS.__init__(self)

	# --- There is no home directory concept in this filesystem

	def set_home_dir(self, homedir):
		assert homedir is None, homedir

	@property
	def root(self):
		# make sure the root has not been set
		origrv = AbstractedFS.root.fget(self)
		assert origrv is None, origrv
		assert False, "Don't call this"

	# ---

	def ftp2fs(self, ftppath):
		import os.path
		fullftp = self.ftpnorm(ftppath)
		assert fullftp[0] == "/", fullftp
		dirparts = fullftp.split("/")
		# there should be a leading /
		assert not dirparts[0], dirparts
		virtdir = dirparts[1]
		if not virtdir:
			assert fullftp == "/", fullftp
			return ShareRoot
		try:
			shrroot = self.shares[virtdir]
		except KeyError:
			raise InvalidPath('Share "{0}" does not exist'.format(virtdir))
		relvirt = "/".join(dirparts[2:])
		if relvirt:
			retval = os.path.join(shrroot, relvirt)
		else:
			retval = shrroot
		retval = os.path.normpath(retval)
		#assert self.validpath(retval), retval
		return retval

	def fs2ftp(self, fspath):
		import os.path
		if fspath in (InvalidPath, ShareRoot):
			return "/"
		for virtdir, shrroot in self.shares.iteritems():
			shrroot = os.path.normpath(shrroot)
			if fspath.startswith(shrroot):
				relvirt = fspath[len(shrroot):]
				relvirt = relvirt.lstrip(os.sep)
				relvirt = relvirt.replace(os.sep, "/")
				ftppath = os.path.join("/" + virtdir, relvirt)
				ftppath = ftppath.replace(os.sep, "/")
				return ftppath
		else:
			assert False, fspath

	def validpath(self, path):
		assert False

	def realpath(self, path):
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
