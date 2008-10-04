CFLAGS = -Wall `pkg-config --cflags gstreamer-0.10` -g
LDFLAGS = -lcurses `pkg-config --libs gstreamer-0.10`

curstar: main.o
	$(CC) -o $@ $^ $(LDFLAGS) $(CFLAGS)

clean:
	$(RM) -fv *.o curstar
