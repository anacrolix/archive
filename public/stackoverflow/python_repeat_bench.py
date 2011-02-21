from __future__ import print_function

import itertools, subprocess, sys

indent = '  '
for repeats in (1, 10, 100, 1000, 10000, 100000, 1000000):
    print('{0} repeats'.format(repeats))
    for setups, statements in [
            ([], ['for x in range({0}): pass'.format(repeats)]),
            (   ['import itertools'],
                ['for x in itertools.repeat(None, {0}): pass'.format(repeats)]),
            (   [], ['for x in list(range({0})): pass'.format(repeats)])]:
        code_args = list(itertools.chain.from_iterable(['-s', setup] for setup in setups)) + statements
        print(indent + subprocess.list2cmdline(code_args))
        for version in ('2.6', '3.1', '3.2'):
            args = ['python'+version, '-m', 'timeit'] + code_args
            print('{0}{1}:'.format(indent * 2, version), end=' ', file=sys.stderr)
            subprocess.check_call(args)

