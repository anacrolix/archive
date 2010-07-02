import inspect

class A:
	def a(self):
		b()

def b():
	#frmobj = inspect.stack()[1][0]
	#name = frmobj.f_code.co_name
	print __name__
	print inspect.stack()[1][3]

A().a()
