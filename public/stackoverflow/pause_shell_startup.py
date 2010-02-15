def _current_process_owns_console():
    #import os, win32api
    #return not win32api.GetConsoleTitle().startswith(os.environ["COMSPEC"])
    import win32console, win32process
    conswnd = win32console.GetConsoleWindow()
    wndpid = win32process.GetWindowThreadProcessId(conswnd)[1]
    curpid = win32process.GetCurrentProcessId()
    return curpid == wndpid

def register_pause_before_closing_console():
    import atexit, os, pdb
    if os.name == 'nt':
        if _current_process_owns_console():
            atexit.register(lambda: os.system("pause"))

if __name__ == '__main__':
    register_pause_before_closing_console()
