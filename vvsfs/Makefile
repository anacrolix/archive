FSTOOLS = truncate mkfs.vvsfs
obj-m := vvsfs.o

all: $(FSTOOLS) vvsfs

vvsfs:
	$(MAKE) -C /usr/src/linux SUBDIRS=$(PWD) modules

clean:
	$(RM) *.o $(FSTOOLS) vvsfs.ko

mkfs.vvsfs.c: vvsfs.h
mkfs.vvsfs: mkfs.vvsfs.c
	$(CC) -std=c99 -o $@ $^
