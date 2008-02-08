CFLAGS = -Wall -g -std=c99 `pkg-config --cflags gtk+-2.0`
LDFLAGS = `pkg-config --libs gtk+-2.0`
CC = gcc
objs = pvpecalc-gtk.o tibia-xp.o
exe = pvpecalc-gtk

all : $(exe)

clean :
	rm -fv *.o

$(exe) : $(objs)
	$(CC) $(LDFLAGS) -o $@ $(objs)

$(objs) : tibia-xp.h
