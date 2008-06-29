import asynchat
import socket
import threading
import asyncore
import time
#import pdb

class MessageDispatcher(asynchat.async_chat):

	MSG_TERM = '\r\n'

	def __init__(self, notify_cb, conn=None):

		if conn == None:
			asynchat.async_chat.__init__(self)
			self.create_socket(socket.AF_INET, socket.SOCK_STREAM)
		else:
			asynchat.async_chat.__init__(self, conn=conn)
		self.notify_cb = notify_cb
		self.buffer = ''
		self.set_terminator(self.MSG_TERM)

	#def writable(self):

		#return not self.connected

	def collect_incoming_data(self, data):

		self.buffer += data

	def found_terminator(self):

		message = eval(self.buffer)
		self.buffer = ''
		# message is always of the form (event, (data))
		assert len(message) == 2
		self.notify(message[0], *message[1])

	def handle_connect(self):

		self.notify('connected')

	def handle_close(self):

		#pdb.set_trace()
		if self.connected:
			self.notify('close')
			print self.connected
			self.close()
			print self.connected

	def notify(self, event, *args):

		self.notify_cb(self, event, *args)

	def send(self, header, *data):

		message = repr((header, data)) + self.MSG_TERM
		bytes_sent = asynchat.async_chat.send(self, message)
		assert bytes_sent == len(message)

class AsyncSockThread(threading.Thread):

	def __init__(self, timeout=1.0):

		threading.Thread.__init__(self)
		self.timeout = timeout

		self.quit = False

	def run(self):

		while True:
			asyncore.loop(timeout=self.timeout)
			print "AsyncSockThread: asyncore has no sockets"
			if self.quit: break
			time.sleep(self.timeout)

	def stop(self):

		self.quit = True

class ServerHandler():

	def send(self, header, *data):

		if not self.dispatcher: return False
		self.dispatcher.send(header, *data)
		#try:
			#self.dispatcher.send(header, *data)
			##self.dispatcher.send(repr((header, data)) + self.LINE_TERM)
		#except socket.error, str:
			#print str
			#self.notify_cb("error", str)
			#return False
		return True

	def __init__(self, notify_cb):

		self.notify_cb = notify_cb
		self.dispatcher = None

	def handle_dispatcher(self, caller, event, *args):

		assert caller == self.dispatcher
		self.notify_cb(event, *args)

	def connect(self, address):

		try: self.dispatcher.close()
		except AttributeError: pass
		self.dispatcher = MessageDispatcher(self.handle_dispatcher)
		self.dispatcher.connect(address)

	def close(self):

		try:
			if self.dispatcher:
				self.dispatcher.close()
		except AttributeError:
			print "lulz you never created a server dispatcher"
