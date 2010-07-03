class Config(object):

	def __init__(self):
		import ConfigParser as configparser
		config = configparser.SafeConfigParser()
		cfgpath = "lanshare.cfg"
		sharesec = "shares"
		config.read(cfgpath)
		try:
			config.add_section(sharesec)
		except configparser.DuplicateSectionError:
			pass
		#from collections import ordereddict
		shares = {}
		import os.path
		for name, value in config.items(sharesec):
			shares[name] = value
		self.shares = shares
		config.write(open(cfgpath, "w"))
