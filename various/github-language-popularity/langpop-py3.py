#!/usr/bin/env python3.2

import logging, urllib.request, urllib.parse, re, concurrent.futures, itertools

def language_popularity(lang):
    qlang = urllib.parse.quote(lang)
    try:
        sub = urllib.request.urlopen("http://github.com/languages/" + qlang).read()
    except:
        logging.exception('Error fetching %r', lang)
        return
    match = re.search(b'is the #(\\d+)', sub)
    if match:
        rank = int(match.group(1))
    else:
        rank = 1
    return rank, lang

def languages():
    for match in re.finditer(b'/languages/([^/]+?)"', urllib.request.urlopen('http://github.com/languages').read()):
        yield urllib.parse.unquote(match.group(1).decode())

def main():
    futures = []
    with concurrent.futures.ThreadPoolExecutor(45) as pool:
        for lang in languages():
            futures.append(pool.submit(language_popularity, lang))
        ranks = {}
        completed = concurrent.futures.as_completed(futures)
        for rank in itertools.count(1):
            while rank not in ranks:
                try:
                    result = next(completed).result()
                except StopIteration:
                    break
                if result is None:
                    continue
                new_rank, lang = result
                ranks[new_rank] = lang
            if rank not in ranks:
                break
            print(rank, ranks[rank])
        for rank1 in sorted(r for r in ranks if r >= rank):
            print(rank1, ranks[rank1])

if __name__ == '__main__':
    main()
