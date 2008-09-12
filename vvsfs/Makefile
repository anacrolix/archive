obj-m := vvsfs.o

default: vvsfs

vvsfs:
	$(MAKE) -C /usr/src/linux SUBDIRS=$(PWD) modules

clean:
	$(RM) *.{o,ko}
