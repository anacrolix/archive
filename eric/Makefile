all: carpark.exe

carpark.exe: carpark.o
	$(CC) $^ -o $@ -lpthread

carpark.o: assignment1.c
	$(CC) $< -c -o $@

clean:
	$(RM) -f *.o carpark.exe
