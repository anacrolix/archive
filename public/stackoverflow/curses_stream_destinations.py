import curses, signal, sys, time

def test_streams():
    print "stdout"
    print >>sys.stderr, "stderr"

def curses_mode(stdscr):
    test_streams()
    time.sleep(1.0)

test_streams()
curses.wrapper(curses_mode)
test_streams()
