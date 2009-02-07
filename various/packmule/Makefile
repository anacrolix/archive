CC = g++
CXXFLAGS = `pkg-config --cflags glib-2.0` -g
LDFLAGS = `pkg-config --libs glib-2.0`

.PHONY: packmule

packmule:
	$(CC) -o $@ packmule.cpp $(CXXFLAGS) $(LDFLAGS)
