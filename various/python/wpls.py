#!/usr/bin/env python3

# wikipedia programming language scraper

import html.parser
import json
import logging
import urllib.request


class Parser(html.parser.HTMLParser):

    # states:
    # 0: nothing
    # 1: influence row
    # 2: link
    # 3: appeared in
    # 4: summary caption

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.__state = 0
        self.influenced_by = {}
        self.influenced = {}
        self.appeared_in = None
        self.summary_caption = None

    def handle_data(self, data):
        if self.__state == 0:
            if data == 'Influenced by':
                self.__state = 1
                self.store = self.influenced_by
            elif data == 'Influenced':
                self.__state = 1
                self.store = self.influenced
            elif data == 'Appeared in':
                self.__state = 3
        elif self.__state == 2:
            self.__state = 1
            self.store[data] = self.__link
        elif self.__state == 3:
            try:
                self.appeared_in = int(data.strip())
            except ValueError:
                pass
        elif self.__state == 4:
            self.summary_caption = data
            self.__state = 0

    def handle_endtag(self, tag):
        if tag == 'tr':
            self.__state = 0

    def handle_starttag(self, tag, attrs):
        if self.__state == 0:
            if tag == 'caption' and dict(attrs).get('class') == 'summary':
                self.__state = 4
        if self.__state == 1:
            if tag != 'a':
                return
            href = dict(attrs).get('href')
            if href is None:
                return
            if href.startswith('/wiki/'):
                self.__state = 2
                self.__link = href

def scrape(path):
    request = urllib.request.Request('http://en.wikipedia.org' + path)
    request.add_header('User-agent', 'Mozilla/5.0')
    response = urllib.request.urlopen(request, timeout=10)
    parser = Parser()
    parser.feed(response.read().decode())
    return {
        key: value for key, value in parser.__dict__.items() if key in [
            'influenced', 'influenced_by', 'appeared_in']}

def scrape_world(pending):
    from concurrent.futures import ThreadPoolExecutor, wait, FIRST_COMPLETED
    from itertools import chain
    logger = logging.getLogger('cf_ordering')
    done_paths = set()
    executor = ThreadPoolExecutor(10)
    futures = set()
    while futures or pending:
        for lang, path in pending.items():
            futures.add(executor.submit(lambda l, p: (l, scrape(p)), lang, path))
            logger.debug('submitted %s', lang)
            done_paths.add(path)
        pending.clear()
        done, futures = wait(futures, return_when=FIRST_COMPLETED)
        for future in done:
            lang, data = future.result()
            logger.debug('got result %s', lang)
            yield lang, data
            for lang, path in chain.from_iterable([
                        data['influenced'].items(),
                        data['influenced_by'].items()
                    ]):
                if path not in done_paths:
                    pending[lang] = path

def main():
    import pprint, sys
    if len(sys.argv) > 1:
        for path in sys.argv[1:]:
            pprint.pprint(scrape(path))
    else:
        logging.root.setLevel(logging.NOTSET)
        for obj in scrape_world({'Python': '/wiki/Python_(programming_language)'}):
            print(json.dumps(obj))

if __name__ == '__main__':
    main()
