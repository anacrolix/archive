#!/usr/bin/env python3

def levenshtein_distance(s, t):
    m = len(s)
    n = len(t)
    d = [[i] + [0] * n for i in range(0, m + 1)]
    d[0] = list(range(0, n + 1))
    for j in range(1, n + 1):
        for i in range(1, m + 1):
            if s[i - 1] == t[j - 1]:
                cost = 0
            else:
                cost = 1
            d[i][j] = min(d[i - 1][j] + 1, d[i][j - 1] + 1, d[i - 1][j - 1] + cost)
    print(d)
    return d[m][n]

from unittest import TestCase, main

class Test(TestCase):
    def test(self):
        self.assertEqual(levenshtein_distance("kitten", "sitting"), 3)
        self.assertEqual(levenshtein_distance("Saturday", "Sunday"), 3)

if __name__ == "__main__":
    main()
