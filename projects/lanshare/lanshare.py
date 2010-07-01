#!/usr/bin/env python

import logging as log

class Multiplexor(object):

	def __init__(self):
		self.channels = []

	def add_channel(self, channel):
		self.channels.append(channel)

	def remove_channel(self, channel):
		self.channels.remove(channel)

	def serve_forever(self):
		while True:
			outchans = []
			inchans = []
			for chan in self.channels:
				if chan.need_write():
					outchans.append(chan)
				if chan.need_read():
					inchans.append(chan)
			from select import select
			inchans, outchans, excchans = select(inchans, outchans, self.channels)
			for chan in excchans:
				chan.handle_except()
			for chan in outchans:
				chan.handle_write()
			for chan in inchans:
				chan.handle_read()

class Channel(object):

	def __init__(self, channel):
		self.__channel = channel

	#def __del__(self):
	#	log.debug("Closing channel %s", self)
	#	self.__channel.close()

	@property
	def channel(self):
		return self.__channel

	#def need_read(self):
	#	raise NotImplementedError

	#def need_write(self):
	#	raise NotImplementedError

	def fileno(self):
		return self.__channel.fileno()

class ServerPi(Channel):

	ENDLINE = "\r\n"

	def __init__(self, sock):
		Channel.__init__(self, sock)
		self.outbuf = ""
		self.inbuf = ""
		self.workdir = ""
		self.type = "A"
		self.push_response(220, "Sup.")

	def push_response(self, code, msg=None):
		assert 100 <= code < 600, code
		if msg is None:
			msg = "No comment"
		assert self.ENDLINE not in msg, msg
		fullmsg = str(code) + " " + msg + self.ENDLINE
		log.info("==> %r", fullmsg)
		self.outbuf += fullmsg

	def need_write(self):
		return len(self.outbuf) > 0

	def need_read(self):
		return True

	def handle_write(self):
		sendcnt = self.channel.send(self.outbuf)
		self.outbuf = self.outbuf[sendcnt:]

	def handle_close(self):
		self.channel.close()
		remove_channel(self)

	def handle_read(self):
		data = self.channel.recv(0x100)
		if not data:
			self.handle_close()
			return
		else:
			self.inbuf += data
		self.process_commands()

	def process_commands(self):
		while True:
			try:
				index = self.inbuf.index(self.ENDLINE)
			except ValueError:
				break
			cmdline = self.inbuf[:index]
			self.inbuf = self.inbuf[index+len(self.ENDLINE):]
			command = cmdline[:4].rstrip(" 1337\r\n").upper()
			log.info("<== %r", cmdline)
			log.debug("Command is %r", command)
			# if there are arguments, there'll be a space before them
			argstr = cmdline[len(command)+1:]
			try:
				method = getattr(self, "interpret_" + command)
			except AttributeError:
				self.push_response(500, "Unknown command")
			else:
				method(argstr)

	def interpret_USER(self, argstr):
		self.username = argstr
		self.push_response(230)

	def interpret_SYST(self, argstr):
		self.push_response(502, "Command not implemented")

	def interpret_PWD(self, argstr):
		pathname = self.workdir
		pathname.replace('"', '""')
		for c in self.ENDLINE:
			assert c not in pathname
		self.push_response(257, '"{0}" is the current directory'.format(pathname))

	def interpret_TYPE(self, argstr):
		self.type = argstr
		self.push_response(200, "Cool bananas")

	def interpret_PASV(self, argstr):
		import socket
		dtsock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
		dtsock.bind((self.channel.getsockname()[0], 0))
		sockname = dtsock.getsockname()
		hostpart = sockname[0].replace(".", ",")
		servpart = "{0},{1}".format(sockname[1] / 256, sockname[1] % 256)
		self.push_response(227, "Entering passive mode ({0},{1}).".format(hostpart, servpart))
		add_channel(PassiveDtp(dtsock))

	def interpret_RETR(self, argstr):
		pass

class PassiveDtp(Channel):

	def __init__(self, sock):
		Channel.__init__(self, sock)

class FtpServer(Channel):

	def __init__(self):
		import socket
		sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
		Channel.__init__(self, sock)
		addr = ("", 1337)
		try:
			sock.bind(addr)
		except socket.error as exc:
			import errno
			if exc.errno == errno.EADDRINUSE:
				log.error("Unable to bind to %s", addr, exc_info=exc)
				log.warning("Falling back to binding to any service")
				#addr[1] = 0
				sock.bind(addr[:1] + (0,))
			else:
				raise
		sock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
		sock.listen(socket.SOMAXCONN)
		log.info("Listening on %s", sock.getsockname())
		#self.socket = sock

	def need_write(self):
		return False

	def need_read(self):
		return True

	def handle_read(self):
		newsock, remaddr = self.channel.accept()
		log.info("Connection from %s", newsock.getpeername())
		add_channel(ServerPi(newsock))

def main():
	import sys
	log.basicConfig(stream=sys.stdout, level=log.DEBUG)
	multiplexor = Multiplexor()
	global add_channel, remove_channel
	add_channel = multiplexor.add_channel
	remove_channel = multiplexor.remove_channel
	add_channel(FtpServer())
	multiplexor.serve_forever()

if __name__ == "__main__":
	main()
