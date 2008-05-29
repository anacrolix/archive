CC = gcc
#CC	= cc
CFLAGS = -std=c99 -D_BSD_SOURCE -D_GNU_SOURCE -O3 -fopenmp -pg
#CFLAGS	= -m64 -Y P,/usr/openwin/lib/amd64:/usr/lib/64:/usr/glut/lib/glut:/usr/lib
LDFLAGS	=
GLIBS   = -lGL -lGLU -lX11 -lm -lglut -lXi -lXmu
OBJS = opengl_stuff.o
 
all: clean mycloth

mycloth:	mycloth.o ${OBJS}
		$(CC) $(CFLAGS) -o $@ mycloth.o ${OBJS} $(LDFLAGS) $(GLIBS)

testcloth:	testcloth.o ${OBJS}
		$(CC) $(CFLAGS) -o $@ testcloth.o ${OBJS} $(LDFLAGS) $(GLIBS)

.SUFFIXES:	.o .c

%.o : %.c
	$(CC) $(CFLAGS) -c $<


clean:
	-/bin/rm -f a.out *.o *~ mycloth testcloth




































