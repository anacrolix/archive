

## Linux
CC      = gcc
CFLAGS  = -I../util -DGL_GLEXT_PROTOTYPES -Wall
LDFLAGS = -L/usr/X11R6/lib
GLIBS   = -lglut -lGLU -lGL -lX11 -lXi -lm -lXmu
 

OBJS = \
	../util/utility.o	\
	../util/glUtils.o	\
	glimage.o

TARGET = image
 
$(TARGET): $(TARGET).c $(OBJS)
	/bin/rm -f $@
	$(CC) $(CFLAGS) -o $@ $(TARGET).c $(OBJS) $(LDFLAGS) $(GLIBS)
 

clean:
	/bin/rm -f *.o $(TARGET)


glimage.o: glimage.h glimage.c
