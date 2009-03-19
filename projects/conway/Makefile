CC = g++
LDFLAGS = -lSDL -lboost_thread-mt
#CXXFLAGS = -O2

default: conway

clean:
	-rm -vf main *.o

conway: main.o
	$(CC) $(LDFLAGS) -o $@ $^ $(CXXFLAGS)
