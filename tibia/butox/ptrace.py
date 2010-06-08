#!/usr/bin/env python

from ctypes.util import find_library
from ctypes import CDLL, CFUNCTYPE
from ctypes import c_long, c_int, c_void_p
from ctypes import get_errno
from os import strerror

_libc = CDLL(find_library("c"), use_errno=True)
_funcspec = ("ptrace", _libc)
_prototype = CFUNCTYPE(c_long, c_int, c_int, c_void_p, c_void_p, use_errno=True)
_paramflags = (1, "request"), (1, "pid"), (1, "addr", None), (1, "data", 0)
def _errcheck(result, func, args):
	if result != 0:
		errno = get_errno()
		raise OSError(errno, strerror(errno))

PTRACE_CONT = 7
PTRACE_ATTACH = 16
PTRACE_DETACH = 17

ptrace = _prototype(_funcspec, _paramflags)
ptrace.errcheck = _errcheck

def ptrace_attach(pid):
	ptrace(pid=pid, request=PTRACE_ATTACH)

def ptrace_detach(pid):
	ptrace(pid=pid, request=PTRACE_DETACH)

def ptrace_cont(pid, signum=0):
	ptrace(pid=pid, request=PTRACE_CONT, data=signum)

def wait_for_tracee_stop(pid):
	from os import waitpid, WIFSTOPPED, WSTOPSIG
	from signal import SIGSTOP
	from sys import stderr
	while True:
		retpid, status = waitpid(pid, 0)
		assert retpid == pid
		assert WIFSTOPPED(status)
		signum = WSTOPSIG(status)
		if signum == SIGSTOP:
			break
		else:
			print >>stderr, "Passing signal to tracee:", signum
			ptrace_cont(pid, signum)

def __main():
	"""Attach, wait for stop, and then detach from pid=sys.argv[1]"""
	import os, signal, sys, time
	pid = int(sys.argv[1])
	ptrace_attach(pid)
	wait_for_tracee_stop(pid)
	ptrace_detach(pid)

if __name__ == "__main__":
	__main()
