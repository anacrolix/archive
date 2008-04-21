all: usematt-static usematt-shared usematt-dynamic

clean:
	-rm -v *.o *.a *.so usematt-{static,shared,dynamic}

# executables

usematt-static : usematt-linked.o libmatt-static.a
	$(CC) -o $@ usematt-linked.o -L. -lmatt-static
usematt-shared : usematt-linked.o libmatt-shared.so
	$(CC) -o $@ usematt-linked.o -L. -lmatt-shared
usematt-dynamic : usematt-dynamic.o libmatt-shared.so
	# require shared library but don't link against it
	# use dynamic linking loader
	$(CC) -o $@ usematt-dynamic.o -ldl
	
# main objects

usematt-linked.o : usematt.c libmatt.h
	$(CC) -o $@ -c usematt.c
usematt-dynamic.o : usematt.c libmatt.h
	# use code to load library at runtime
	$(CC) -o $@ -c usematt.c -DDYNAMIC

# libraries

libmatt-static.a : libmatt-static.o
	# binary archive with object-file index
	$(AR) -rcs $@ libmatt-static.o
libmatt-shared.so : libmatt-shared.o
	$(CC) -o $@ -shared libmatt-shared.o

# library objects

libmatt-static.o : libmatt.c
	$(CC) -o $@ -c libmatt.c
libmatt-shared.o : libmatt.c
	# position indepedent code
	$(CC) -o $@ -c -fPIC libmatt.c
