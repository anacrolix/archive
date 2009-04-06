import sys

class TermInfo():
    try: import curses
    except ImportError: import fakecurs as curses
    # there are normal colors too, might not need them. this. is. ANSIIIII
    _ANSI_COLORS = """BLACK RED GREEN YELLOW BLUE MAGENTA CYAN WHITE""".split()
    _STRING_CAPS = """NORMAL=sgr0""".split()
    # some of the stuff in this function might need to be rearranged as exceptions arise
    # on different platforms
    def __init__(self, stream=sys.stdout):
        self.curses.setupterm(None, stream.fileno())
        for prefix, capstr in [("FG_", "setaf"), ("BG_", "setab")]:
            for index, color in zip(range(len(self._ANSI_COLORS)), self._ANSI_COLORS):
                setattr(self, prefix + color, self.curses.tparm(self.curses.tigetstr(capstr), index))
        for strcap in self._STRING_CAPS:
            attr, capstr = strcap.split("=")
            setattr(self, attr, self.curses.tigetstr(capstr))
        self.stream = stream
    def __del__(self):
        self.stream.write(self.NORMAL)
        self.stream.flush()
        pass

class ResetTerm:
    def __del__(self):
        sys.stdout.write(TermInfo(sys.stdout).NORMAL)

stdout_terminal_normalizer = ResetTerm()
