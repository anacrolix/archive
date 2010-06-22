#!/usr/bin/env python

from __future__ import division
__all__ = ["monotonic_time"]
import ctypes, os, sys

if sys.platform == "win32":
	GetTickCount64 = ctypes.windll.kernel32.GetTickCount64
	GetTickCount64.restype = ctypes.c_ulonglong
	def monotonic_time():
		return GetTickCount64() / 1000
else:
	CLOCK_MONOTONIC = 1 # see <linux/time.h>
	class timespec(ctypes.Structure):
		_fields_ = [
			('tv_sec', ctypes.c_long),
			('tv_nsec', ctypes.c_long)
		]
	librt = ctypes.CDLL('librt.so.1', use_errno=True)
	clock_gettime = librt.clock_gettime
	clock_gettime.argtypes = [ctypes.c_int, ctypes.POINTER(timespec)]
	def monotonic_time():
		t = timespec()
		if clock_gettime(CLOCK_MONOTONIC, ctypes.pointer(t)) != 0:
			errno_ = ctypes.get_errno()
			raise OSError(errno_, os.strerror(errno_))
		return t.tv_sec + t.tv_nsec / 1e9

if __name__ == "__main__":
	print monotonic_time()
