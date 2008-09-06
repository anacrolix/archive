CFLAGS = -std=c99 -g -Wall

all: clean ssltest

clean:
	-rm -fv *.o ssltest

ssltest: ssltest.o minrsa.o
	$(CC) -o $@ $^ -lcrypto
