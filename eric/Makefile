all: carpark.exe

carpark.exe: carpark.o
	cc carpark.o -o carpark.exe -lpthread

carpark.o:
	cc assignment1.c -c -o carpark.o

clean:
	rm -f *.o carpark.exe
