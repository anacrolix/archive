

## Linux
CC      = gcc
CFLAGS  = -I../util -DGL_GLEXT_PROTOTYPES -Wall
LDFLAGS = -L/usr/X11R6/lib
GLIBS   = -lglut -lGLU -lGL -lX11 -lXi -lm -lXmu
 

OBJS = \
	../util/utility.o	\
	../util/glUtils.o	\
	retro.o			\
	tty.o

TARGET = retro
 
$(TARGET): $(OBJS)
	/bin/rm -f $@
	$(CC) $(CFLAGS) -o $@ $(OBJS) $(LDFLAGS) $(GLIBS)
 

clean:
	/bin/rm -f *.o $(TARGET)


tty.o: tty.h tty.c

retro.o: tty.h retro.c
