import collections
import itertools
import pdb
from treeops import transverse_order

class AhoCorasick(object):
    def __init__(self, patterns):
        #print
        #print patterns
        automata = [[{}, None, set()]]
        for outi, pat in enumerate(patterns):
            state = 0
            syms = iter(pat)
            skip = False
            for s in syms:
                try:
                    state = automata[state][0][s]
                except KeyError:
                    break
            else:
                skip = True
            if not skip:
                for s in itertools.chain([s], syms):
                    automata[state][0][s] = len(automata)
                    state = len(automata)
                    automata.append([{}, None, set()])
            automata[state][2].add(outi)
        #for node in enumerate(automata):
            #print node
        def transverse_order(root):
            for symbol, child in automata[root][0].iteritems():
                yield root, symbol, child
            for child in automata[root][0].values():
                for recurse in transverse_order(child):
                    yield recurse
        #pdb.set_trace()
        for parent, symbol, child in transverse_order(0):
            down = automata[parent][1]
            while down != None and not automata[down][0].has_key(symbol):
                down = automata[down][1]
            if down != None:
                automata[child][1] = automata[down][0][symbol]
                automata[child][2] |= automata[automata[child][1]][2]
            else:
                automata[child][1] = 0
        for node in automata:
            final = []
            for which in node[2]:
                final.append((which, len(patterns[which])))
            node[2] = final
        #for node in enumerate(automata):
            #print node
        self.automata = automata

    def __call__(self, text, report):
        current = 0
        for pos, symbol in enumerate(text):
            while not self.automata[current][0].has_key(symbol) and self.automata[current][1] != None:
                current = self.automata[current][1]
            if self.automata[current][0].has_key(symbol):
                current = self.automata[current][0][symbol]
            else:
                current = 0
            for which, size in self.automata[current][2]:
                report(which, pos - size + 1)
