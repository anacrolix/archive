class wheatstone_cipher:
	def __init__(self, key=None):
		self.set_key(key)
	def set_key(self, key):
		self.key = key
	def update_table(self):
		self.table = []
		#for 

wc = wheatstone_cipher()

print "hi"
print wc.key
wc.update_table()
