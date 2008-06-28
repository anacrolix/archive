import asynchat
import socket

class MessageDispatcher(asynchat.async_chat):

	MSG_TERM = '\r\n'

	def __init__(self, notify_cb, conn=None):

		if conn == None:
			asynchat.async_chat.__init__(self)
			self.create_socket(socket.AF_INET, socket.SOCK_STREAM)
		else:
			asynchat.async_chat.__init__(self, conn)
		self.notify_cb = notify_cb
		self.buffer = ''
		self.set_terminator(self.MSG_TERM)

	def writable(self):

		return not self.connected

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

	def notify(self, event, *args):

		self.notify_cb(self, event, *args)

	def send(self, header, *data):

		asynchat.async_chat.send(self, repr((header, data)) + self.MSG_TERM)
