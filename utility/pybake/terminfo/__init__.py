try:
    import curses
except ImportError:
    import fakecurs as curses

import sys

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
    def __del__(self):
        self.reset()
    def reset(self):
        self.immediate(self.NORMAL)
    def immediate(self, tistr):
        self.stream.write(tistr)
        self.stream.flush()
