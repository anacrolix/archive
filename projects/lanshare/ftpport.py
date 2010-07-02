#!/usr/bin/env python

def ftp_port_arg(*args):
	if len(args) == 1:
		port = int(args[0])
		print "%d,%d" % (port / 256, port % 256)
	else:
		assert False, args

def ftp_eprt_arg():
	print "EPRT stub"

def main():
	from optparse import OptionParser
	parser = OptionParser()
	parser.add_option("-6", dest="extended", action="store_true", default=False, help="print EPRT argument")
	options, posargs = parser.parse_args()
	method = ftp_eprt_arg if options.extended else ftp_port_arg
	method(*posargs)

if __name__ == "__main__":
	main()
