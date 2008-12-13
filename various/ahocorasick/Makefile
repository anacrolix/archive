CC = g++
CXXFLAGS = -g #-pg -fprofile-arcs -ftest-coverage
LDFLAGS = #-pg -fprofile-arcs -ftest-coverage

default: clean test
	make -f Makefile.makeinput
clean:
	-rm -f test *.o
test:
test.o: test.cpp ahocorasick.hpp
