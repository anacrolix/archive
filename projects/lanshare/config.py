import ConfigParser as configparser

class SectionDict(object):

	def __init__(self, cfgwrap, cfgparse, section):
		self.__cfgwrap = cfgwrap
		self.__cfgparse = cfgparse
		self.__section = section

	def iteritems(self):
		for pair in self.__cfgparse.items(self.__section):
			yield pair

	def __delitem__(self, key):
		assert self.__cfgparse.remove_option(self.__section, key)
		self.__cfgwrap.save()

	def __setitem__(self, key, value):
		self.__cfgparse.set(self.__section, key, value)
		self.__cfgwrap.save()

	def keys(self):
		return self.__cfgparse.options(self.__section)

	def __getitem__(self, key):
		try:
			return self.__cfgparse.get(self.__section, key)
		except configparser.NoOptionError:
			raise KeyError()

	def values(self):
		for option, value in self.__cfgparse.items(self.__section):
			yield value

class Config(object):

	sharesec = "shares"
	cfgpath = "lanshare.cfg"

	def __init__(self):
		import ConfigParser as configparser
		self.__config = configparser.SafeConfigParser()
		self.__config.read(self.cfgpath)
		try:
			self.__config.add_section(self.sharesec)
		except configparser.DuplicateSectionError:
			pass

	def save(self):
		self.__config.write(open(self.cfgpath, "wb"))

	@property
	def shares(self):
		return SectionDict(self, self.__config, self.sharesec)
