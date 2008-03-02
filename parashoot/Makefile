CC = gcc
CFLAGS = -std=c99
LDFLAGS = -lSDL
OBJS = main.o control.o view.o model.o

all: parashoot

parashoot: $(OBJS)
	$(CC) $(LDFLAGS) -o $@ $(OBJS)

$(OBJS): error.h
control.o: view.h
main.o: control.h
