FSTOOLS = truncate mkfs.vvsfs
KSRCDIR = /usr/src/linux
obj-m := vvsfs.o

all: $(FSTOOLS) vvsfs

vvsfs:
	$(MAKE) -C $(KSRCDIR) SUBDIRS=$(PWD) modules

clean:
	$(RM) *.o $(FSTOOLS) vvsfs.ko

mkfs.vvsfs.c: vvsfs.h
mkfs.vvsfs: mkfs.vvsfs.c
	$(CC) -std=c99 -o $@ $^
