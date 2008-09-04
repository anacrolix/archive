all: usematt-static usematt-shared usematt-dynamic

clean:
	-rm -v *.o *.a *.so usematt-{static,shared,dynamic}

# executables

# NOTE: to run the shared and dynamic exes, you must tell the dynamic link loader
#	where to find the shared library libmatt-shared.so. It must be in your
#	LD_LIBRARY_PATH.

# LINKING METHODS:
# static: Object code is imported and linked at compile time.
# shared: Linked at run-time at locations predetermined at compile time.
# dynamic: Linked at run-time, and special provisions are made in the source \
#	to call it wherever it is loaded to.

usematt-static : usematt-linked.o libmatt-static.a
	# note that libmatt-static.a can also be linked in using -L. -lmatt-static
	$(CC) -o $@ usematt-linked.o libmatt-static.a
usematt-shared : usematt-linked.o libmatt-shared.so
	# note that libmatt-static.a can also be linked in using libmatt-shared.so
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
	# position independent code
	$(CC) -o $@ -c -fPIC libmatt.c
