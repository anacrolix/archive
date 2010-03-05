import httplib

a = httplib.HTTPConnection(
        #"www.tibia.com"
        "localhost", port=3000,
    )
a.request("GET", "/community/?subtopic=whoisonline&world=Dolera", headers={"Keep-Alive": 115, "Connection": "keep-alive", "User-Agent": "Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2) Gecko/20100301 Ubuntu/9.10 (karmic) Firefox/3.6"})
b = a.getresponse()
print b.getheaders()
