#!/usr/bin/env python

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

def solve(sudoku):
    for index, value in enumerate(sudoku):
        assert 1 <= value <= 9 or value is None
        if value:
            continue
        for trial in xrange(1, 10):
            if trial in domain(sudoku, index):
                continue
            solution = Sudoku(sudoku[:])
            solution[index] = trial
            print
            print solution
            solution = solve(solution)
            if solution:
                return solution
        else:
            return None
    else:
        return sudoku

class Sudoku(list):

    def __str__(self):
        assert len(self) == 81
        s = [" " if not i else str(i) for i in self]
        s = [iter(s)] * 9
        s = "\n".join("|".join(row) for row in zip(*s))
        return s

input = [
        "   54   1",
        "  18    4",
        "69    582",
        "1 63  8  ",
        "  32981  ",
        "  8  67 5",
        "879    13",
        "4    32  ",
        "3   74   ",]
input = "".join(input)
input = list(input)
input = [None if i is " " else int(i) for i in input]
#pdb.set_trace()
input = Sudoku(input)
print input
#pdb.set_trace()
solution = solve(input)
print
print solution
