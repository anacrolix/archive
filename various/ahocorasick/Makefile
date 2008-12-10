CC = g++
CXXFLAGS = -O2 -pg -fprofile-arcs -ftest-coverage
LDFLAGS = -pg -fprofile-arcs -ftest-coverage

default: clean test
clean:
	-rm -f test *.o
test:
test.o: test.cpp ahocorasick.hpp
