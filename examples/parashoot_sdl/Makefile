CC = gcc
CFLAGS = -std=c99 -DDEBUG
LDFLAGS = -lSDL -lSDL_image -lm
OBJS = main.o control.o view.o model.o

all: parashoot

clean:
	rm -v *.o

parashoot: $(OBJS)
	$(CC) $(LDFLAGS) -o $@ $(OBJS)

$(OBJS): error.h
control.o: view.h
main.o: control.h
