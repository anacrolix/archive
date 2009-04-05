import curses
import sys

class TermInfo:
    # there are normal colors too, might not need them. this. is. ANSIIIII
    _ANSI_COLORS = """BLACK RED GREEN YELLOW BLUE MAGENTA CYAN WHITE""".split()
    _STRING_CAPS = """NORMAL=sgr0""".split()
    # some of the stuff in this function might need to be rearranged as exceptions arise
    # on different platforms
    def __init__(self, stream=sys.stdout):
        curses.setupterm()
        for prefix, capstr in [("FG_", "setaf"), ("BG_", "setab")]:
            for index, color in zip(range(len(self._ANSI_COLORS)), self._ANSI_COLORS):
                setattr(self, prefix + color, curses.tparm(curses.tigetstr(capstr), index))
        for strcap in self._STRING_CAPS:
            attr, capstr = strcap.split("=")
            setattr(self, attr, curses.tigetstr(capstr))
        self.stream = stream
    def __del__(self):
        #self.stream.write(self.NORMAL)
        pass

class ResetTerm:
    def __del__(self):
        sys.stdout.write(TermInfo(sys.stdout).NORMAL)

stdout_terminal_normalizer = ResetTerm()
