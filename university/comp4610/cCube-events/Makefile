

## Linux
CC      = gcc
CFLAGS  = -I../util -DGL_GLEXT_PROTOTYPES -Wall
LDFLAGS = 
GLIBS   = -lglut -lGLU -lGL -lX11 -lXi -lm -lXmu
 

OBJS = \
	../util/utility.o	\
	../util/glUtils.o	\

TARGET = cube
 
$(TARGET): $(TARGET).c $(OBJS)
	/bin/rm -f $@
	$(CC) $(CFLAGS) -o $@ $(TARGET).c $(OBJS) $(LDFLAGS) $(GLIBS)
 

clean:
	/bin/rm -f *.o $(TARGET)


cube.o: cube.c
