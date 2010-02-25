import collections, os.path, pdb, pprint, re, string, sys, time, urllib2

from . import url, parse
from pretty import *

#_TIBIA_TIME_STRLEN = len("Mon DD YYYY, HH:MM:SS TZ")

def http_get(url, retries=3):
    """Perform a compressed GET request on the Tibia webserver. Return the decoded response data and other info."""

    # prefer deflate, zlib, gzip as they add ascending levels of headers in that order
    # compress is not as strong compression, prefer it next, avoid identity and unhandled encodings at all cost
    request = urllib2.Request(
            url,
            headers={"Accept-Encoding": "deflate;q=1.0, zlib;q=0.9, gzip;q=0.8, compress;q=0.7, *;q=0"},)
    try:
        response = urllib2.urlopen(request); del request
    except urllib2.HTTPError as e:
        if retries > 0:
            print >>sys.stderr, "Error reading %r: %s" % (url, e)
            return http_get(url, retries - 1)
        else:
            raise
    assert response.code == 200

    # decompress the response data
    respdata = response.read()
    assert len(respdata) == int(response.info()["Content-Length"])
    contentEncoding = response.info()["Content-Encoding"]
    if contentEncoding == "gzip":
        import gzip, io
        respdata = gzip.GzipFile(fileobj=io.BytesIO(respdata)).read()

    # retrieve the encoding, so we can decode the bytes to a string
    contentType = response.info()["Content-Type"]
    charset = re.search("charset=([^;\b]+)", contentType).group(1)

    if str != bytes:
        respdata = respdata.decode(charset)
    return respdata, response.info()

def get_char_info(name):
    html = http_get(url.char_page(name))[0]
    return parse.char_page(html, name)
