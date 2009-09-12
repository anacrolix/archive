class StrFind(object):
    def __init__(self, pattern):
        self.pattern = pattern
    def __call__(self, text, report):
        where = -1
        while True:
            where = text.find(self.pattern, where + 1)
            if where != -1: report(where)
            else: break
