from shelve_dep import a

class Blah:
    def __del__(self):
        a["hello"] = "world"
