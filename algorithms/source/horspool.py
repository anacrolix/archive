#import psyco

class Horspool:
    def __init__(self, pattern):
        self.m = len(pattern)
        self.d = [self.m for i in xrange(256)]
        for j in range(1, self.m):
            self.d[ord(pattern[j - 1])] = self.m - j
        self.p = pattern
    #@psyco.proxy
    def __call__(self, text, report):
        pos = 0
        end = len(text) - self.m
        while pos <= end:
            j = self.m - 1
            while j > -1 and text[pos + j] == self.p[j]:
                j -= 1
            if j == -1: report(pos)
            pos += self.d[ord(text[pos + self.m - 1])]
