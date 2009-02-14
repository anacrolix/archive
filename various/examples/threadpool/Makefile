CC = g++
CXXFLAGS = -g -O0
LDFLAGS = -lboost_thread-mt

default: test

clean:
	-rm -f test *.o

test: test.o

test.o: test.cpp ThreadPool.hpp
