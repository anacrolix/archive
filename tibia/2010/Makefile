CFLAGS = -std=c99 -O2

all: ptraceidle readmem xsendkey getxwin

xsendkey: xsendkey.c
	$(CC) -o $@ $^ $(CFLAGS) -lX11

getxwin: getxwin.c
	$(CC) -o $@ $^ $(CFLAGS) -lX11
