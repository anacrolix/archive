#!/usr/bin/env python3

from collections import defaultdict
import json
import sys

def fix_lang(lang):
    return lang.capitalize().replace('-', ' ').strip()

def influenced(lang, lang2, graph):
    checked = set()
    unchecked = set(graph.get(lang, ()))
    while unchecked:
        for lang in unchecked.copy():
            for influenced in graph.get(lang, ()):
                if influenced == lang2:
                    return True
                unchecked.add(influenced)
            checked.add(lang)
        unchecked -= checked
    return False

def main():
    graph = {}
    for line in sys.stdin:
        lang, data = json.loads(line)
        lang = fix_lang(lang)
        for by in data['influenced_by']:
            graph.setdefault(fix_lang(by), set()).add(lang)
        for on in data['influenced']:
            graph.setdefault(lang, set()).add(fix_lang(on))
    new_graph = {'Python': ()}
    while True:
        for lang, on in graph.items():
            meh = on & new_graph.keys()
            new_graph.setdefault(lang, set()).update(meh)
            for a in meh:
                if a not in
                break
        else:
            break
    graph = new_graph
    print('digraph {')
    #~ print('\tconcentrate=true')
    for lang, on in graph.items():
        print('\t"{lang}"->{{{}}}'.format(';'.join(map('"{}"'.format, on)), **vars()))
    print('}')

main()
