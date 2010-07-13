#!/usr/bin/env python

import itertools
import pdb

def domain(sudoku, index):
    #pdb.set_trace()
    row = index // 9
    col = index % 9
    box = 3*(row//3) + col//3
    for i in xrange(9):
        yield sudoku[9*row+i]
        yield sudoku[9*i+col]
        yield sudoku[9*(3*(box//3)+(i//3))+3*(box%3)+i%3]

#def domain(*args):
#    return filter(None, _domain(*args))

def solve(sudoku, callback=None):
    for index, value in enumerate(sudoku):
        assert 1 <= value <= 9 or value is None, value
        if value:
            continue
        for trial in xrange(1, 10):
            if trial in domain(sudoku, index):
                continue
            solution = Sudoku(sudoku[:])
            solution[index] = trial
            if not callback is None:
                callback(solution)
            solution = solve(solution)
            if solution:
                return solution
        else:
            return None
    else:
        return sudoku

class Sudoku(object):

    def __init__(self, input):
        import itertools
        if len(input) == 9:
            output = []
            for row in input:
                for col in xrange(9):
                    try:
                        cell = row[col]
                    except IndexError:
                        cell = None
                    output.append(cell)
            input = output
        assert len(input) == 81, len(input)
        def fix_value(x):
            if x in (" ", None):
                return None
            else:
                return int(x)
        input = map(fix_value, input)

        self.__values = input

    def __str__(self):
        assert len(self) == 81
        s = [" " if not i else str(i) for i in self]
        s = [iter(s)] * 9
        s = "\n".join("|".join(row) for row in zip(*s))
        return s

    def __iter__(self):
        return iter(self.__values)

    def __getitem__(self, key):
        return self.__values[key]

    def __setitem__(self, key, value):
        self.__values.__setitem__(key, value)

    def __len__(self):
        return 81

    def __eq__(self, other):
        return self.__values == other.__values

    def find_solution(self):
        return solve(self)

#input = "".join(input)
#input = list(input)
#input = [None if i is " " else int(i) for i in input]
##pdb.set_trace()
#input = Sudoku(input)
#print input
##pdb.set_trace()
#solution = solve(input)
#print
#print solution

def run_tests():
    inputs = [
            [   "   54   1", "287549361",
                "  18    4", "531862974",
                "69    582", "694731582",
                "1 63  8  ", "146357829",
                "  32981  ", "753298146",
                "  8  67 5", "928416735",
                "879    13", "879625413",
                "4    32  ", "465183297",
                "3   74   ", "312974658",],
        ]
    #pdb.set_trace()
    for test in inputs:
        puzzle = Sudoku(test[0::2])
        answer = Sudoku(test[1::2])
        solution = puzzle.find_solution()
        assert solution == answer, (solution, answer)

def main():
    import optparse
    parser = optparse.OptionParser()
    parser.add_option("--run-tests", default=False, action="store_true")
    options, posargs = parser.parse_args()
    if options.run_tests:
        run_tests()
    else:
        import sys
        input = []
        for line in sys.stdin:
            line = line.rstrip("\n")
            assert len(input) <= 9 or not line, "Too many rows given!"
            input.append(line)
        # input is now a list of strings
        solution = Sudoku(input).find_solution()
        print
        print solution

if __name__ == "__main__":
    main()
