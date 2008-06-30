import asynchat
import socket
import threading
import asyncore
import time

class MessageDispatcher(asynchat.async_chat):

	MSG_TERM = '\r\n'

	def __init__(self, notify_cb, conn=None):

		asynchat.async_chat.__init__(self, conn=conn)
		self.notify_cb = notify_cb
		self.set_terminator(self.MSG_TERM)
		self.buffer = ''

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

		if self.connected:
			self.notify('close')
			self.close()

	def send(self, header, *data):

		message = repr((header, data)) + self.MSG_TERM
		bytes_sent = asynchat.async_chat.send(self, message)
		assert bytes_sent == len(message)

	def connect(self, address):

		print "MessageDispatcher.connect(", address, ")"
		try: self.close()
		except AttributeError, wtf: print wtf
		self.create_socket(socket.AF_INET, socket.SOCK_STREAM)
		self.buffer = ''
		#print "starting connect"
		#self.settimeout(3.0)
		self.setblocking(1)
		asynchat.async_chat.connect(self, address)
		assert self.connected
		#self.setblocking(0)
		print "finished waiting for connect"

	def notify(self, event, *args):

		self.notify_cb(self, event, *args)

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
