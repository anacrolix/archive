CC      = gcc
CFLAGS = -Wall
LDFLAGS = 
GLIBS   = -lglut -lGLU -lGL -lX11 -lXi -lm -lXmu

OBJS = robot.o glutil.o

TARGET = ass2
 
$(TARGET): $(TARGET).c $(OBJS)
	/bin/rm -f $@
	$(CC) $(CFLAGS) -o $@ $(TARGET).c $(OBJS) $(LDFLAGS) $(GLIBS)
 
clean:
	/bin/rm -f *.o $(TARGET)

robot.o: robot.h glutil.h robot.c

ass2.o: robot.h ass2.c

glutil.o: glutil.h glutil.c
