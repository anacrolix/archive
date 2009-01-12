import time

def unix_utc():
	return int(time.mktime(time.gmtime()))
