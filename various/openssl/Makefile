CFLAGS = -std=c99 -g

all: clean ssltest

clean:
	-rm -fv *.o ssltest

ssltest: ssltest.o
	$(CC) -o $@ $< -lcrypto
