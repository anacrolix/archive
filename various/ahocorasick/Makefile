CC = g++
CXXFLAGS = -g -Wall -pg
LDFLAGS = -pg

default: clean test
clean:
	-rm -f test *.o
test:
test.o: test.cpp ahocorasick.hpp
