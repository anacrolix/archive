#!/usr/bin/env python

import sys

class TerminalColor(object):
    pass

def curses_color():
    import curses
    class TermInfo():
	# this. is. ANSIIIII!!!
	_ANSI_COLORS = """BLACK RED GREEN YELLOW BLUE MAGENTA CYAN WHITE""".split()
	_STRING_CAPS = """NORMAL=sgr0""".split()
	def __init__(self, stream=sys.stdout):
	    # isatty might be needed here?
	    curses.setupterm(None, stream.fileno())
	    for prefix, capname in [("FG_", "setaf"), ("BG_", "setab")]:
		for index, color in zip(range(len(self._ANSI_COLORS)), self._ANSI_COLORS):
		    setattr(self, prefix + color, curses.tparm(curses.tigetstr(capname), index))
	    for strcap in self._STRING_CAPS:
		attr, capname = strcap.split("=")
		setattr(self, attr, curses.tigetstr(capname))
	    self.stream = stream
	#def __del__(self):
	#    self.reset()
	def reset(self):
	    self.immediate(self.NORMAL)
	def immediate(self, tistr):
	    self.stream.write(tistr)
	    self.stream.flush()
	def save_color(self):
	    return None
	def set_color(self, color):
	    self.immediate(getattr(self, "FG_" + color.upper()))
	def reset_color(self):
	    #self.immediate(self.__color)
	    self.reset()
    return TermInfo

def windows_color():
    class COORD(ctypes.Structure):
	_fields_ = [
		("X", wintypes.SHORT),
		("Y", wintypes.SHORT),]
    class CONSOLE_SCREEN_BUFFER_INFO(ctypes.Structure):
	_fields_ = [
		("dwSize", COORD),
		("dwCursorPosition", COORD),
		("wAttributes", wintypes.WORD),
		("srWindow", wintypes.SMALL_RECT),
		("dwMaximumWindowSize", COORD),]

    _stdoutHandle = ctypes.windll.kernel32.GetStdHandle(wintypes.DWORD(-11))
    assert not _stdoutHandle == wintypes.DWORD(-1)

    class WindowsTerminalColor(TerminalColor):
	FOREGROUND_BLUE      = 0x0001
	FOREGROUND_GREEN     = 0x0002
	FOREGROUND_RED       = 0x0004
	FOREGROUND_INTENSITY = 0x0008
	FOREGROUND_MASK      = 0x000f
	BACKGROUND_BLUE      = 0x0010
	BACKGROUND_GREEN     = 0x0020
	BACKGROUND_RED       = 0x0040
	BACKGROUND_INTENSITY = 0x0080
	BACKGROUND_MASK      = 0x00f0
	def __get_attributes(self):
	    a = CONSOLE_SCREEN_BUFFER_INFO()
	    assert ctypes.windll.kernel32.GetConsoleScreenBufferInfo(_stdoutHandle, ctypes.pointer(a))
	    return a.wAttributes
	def save_color(self):
	    assert not hasattr(self, "__color")
	    self.__color = self.__get_attributes() & self.FOREGROUND_MASK
	def set_color(self, color):
	    attributes = self.__get_attributes()
	    attributes &= ~self.FOREGROUND_MASK
	    attributes |= {
		    "blue": self.FOREGROUND_BLUE,
		    "cyan": self.FOREGROUND_BLUE | self.FOREGROUND_GREEN,
		    "green": self.FOREGROUND_GREEN,
		    "magenta": self.FOREGROUND_RED | self.FOREGROUND_BLUE,
		    "red": self.FOREGROUND_RED,
		    "yellow": self.FOREGROUND_GREEN | self.FOREGROUND_RED,
		}[color]
	    attributes |= self.FOREGROUND_INTENSITY
	    ctypes.windll.kernel32.SetConsoleTextAttribute(_stdoutHandle, wintypes.WORD(attributes))
	    return self
	def reset_color(self):
	    attributes = self.__get_attributes() & ~self.FOREGROUND_MASK | self.__color
	    assert ctypes.windll.kernel32.SetConsoleTextAttribute(_stdoutHandle, attributes)

    return WindowsTerminalColor

import contextlib

@contextlib.contextmanager
def set_color(color):
    a = __default()
    a.save_color()
    a.set_color(color)
    try:
	yield
    finally:
	a.reset_color()

def select_color():
    try:
	import curses
    except ImportError:
	import ctypes
	try:
	    from ctypes import wintypes
	finally:
	    pass
	return windows_color()
    else:
	return curses_color()
    assert False

__default = select_color()

if __name__ == "__main__":
    print "default",
    with set_color("red"):
	print "red",
	with set_color("yellow"):
	    print "yellow",
	    with set_color("green"):
		print "green",
		with set_color("blue"):
		    print "blue",
		print "green",
	with set_color("magenta"):
	    print "magenta",
	print "red",
	with set_color("cyan"):
	    print "cyan",
    with set_color("blue"):
	print "blue",
    with set_color("red"):
	print "red",
    print "default",
	#raise
