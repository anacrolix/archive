CFLAGS = -std=c99 -O2

all: ptraceidle readmem xsendkey getxwin monoclk

xsendkey: xsendkey.c
	$(CC) -o $@ $(CFLAGS) -lX11 $^

getxwin: getxwin.c
	$(CC) -o $@ $(CFLAGS) -lX11 $^

monoclk: monoclk.c
	$(CC) -o $@ $(CFLAGS) -lrt $^
