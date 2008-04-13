CFLAGS = -I'/usr/include/python2.4' -fPIC -std=c99 -Wall

all: md.so
	
clean:
	-rm -vf md.o md.so

md.so: md.o
	$(CC) -shared -o $@ $^
