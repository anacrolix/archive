#include <sys/time.h>
#include <assert.h>
#include <ctype.h>
#include <errno.h>
#include <math.h>
#include <pthread.h>
#include <semaphore.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <termios.h>
#include <time.h>
#include <unistd.h>

/* max number of cars the carpark can hold */
#define CAR_PARK_SIZE 10

/* prob of arrival of car */
#define ARRIVAL_PERCENT_ACTION 60

/* prob of departure of car */
#define DEPARTURE_PERCENT_ACTION 40

/* milliseconds to sleep between arrivals/departures */
#define TIME_OUT_SLEEP 800

typedef struct {
	char *buffer[CAR_PARK_SIZE];	///< stores carpark cars
	int  keep_running;		///< set false to exit threads
	int  size;			///< car parks left
	sem_t empty;
	sem_t full;
	pthread_mutex_t mutex;
} CarPark;

CarPark carpark; ///< our global carpark

void *monitor(void *arg);
void *arrival(void *arg);
void *departure(void *arg);
void add_car(char *car);
void remove_car();
void show_cars();
char *new_car();
char *theTime();
char grabChar();
int rand_i(int min, int max);
int sleep_ms(unsigned long milisec);

int sleep_ms(unsigned long ms)
{
	struct timespec req = {0};
	time_t sec = ms / 1000;
	ms = ms - (sec * 1000);
	req.tv_sec = sec;
	req.tv_nsec = ms * 1e6L;
	while (nanosleep(&req, &req) == -1);
	return 1;
}

int main(int argc, char *argv[])
{
	srand(time(NULL));

	carpark.size = CAR_PARK_SIZE; //it's empty
	carpark.keep_running = 1; //let it ruunn

	//Initialize the the locks
	pthread_mutex_init(&carpark.mutex, NULL);
	sem_init(&carpark.empty, 0, CAR_PARK_SIZE);
	sem_init(&carpark.full, 0, 0);

	//Create the monitor thread (listens to the keyboard and does printing)..
	pthread_t tid;
	pthread_attr_t attr;
	pthread_attr_init(&attr);

	if (pthread_create(&tid, &attr, monitor, NULL))
	{
		printf("Error creating monitor thread.. :' (");
		abort();
	}


	//Create the arrival thread
	//hmm, i wonder if I can reuse the above variables? Stupid memory managment. I'll play it safe
	pthread_t tid2;
	pthread_attr_t attr2;
	pthread_attr_init(&attr2);
	if( pthread_create(&tid2, &attr2, arrival, NULL) )
    {
        printf("Error creating arrival thread.. :' (");
        abort();
    }


	//Create the departure thread
	pthread_t tid3;
	pthread_attr_t attr3;
	pthread_attr_init(&attr3);
	if( pthread_create(&tid3, &attr3, departure, NULL) )
    {
        printf("Error creating departure thread.. :' (");
        abort();
    }


	///hmmmm, now don't exit. lol.
	//wait for 'em all to finish
	pthread_join(tid, NULL);

	return 0;
}

int rand_i(int min, int max)
{
	double roll = rand() / (RAND_MAX + 1.0); // [0.0, 1.0)
	int range = max + 1 - min; // [min, max + 1]
	int result = min + floor(roll * range); //
	assert(result >= min && result <= max);
}




char *new_car() //generate a new name for a car
{
	char* str = malloc(12); //size of car string
	int i; //counter


	//how a man makes a string

	str[0] = (char) rand_i('A','Z'); //random letter
	str[1] = (char) rand_i('A','Z');
	str[2] = ' ';
	str[3] = (char) rand_i('1','9'); //first digit must not be a zero

	for(i = 4; i < 11; i++)
		str[i] = (char) rand_i('0','9');

	str[11] = '\0';

	//You liked that? didn't you?



	return str;

}

char* theTime()
{
	time_t x;
	x = time(&x);

	char* t = ctime(&x);

	t[strlen(t)-1] = ' '; //replace new line with space
	
	return t;
}



char grabChar()
{
	int i;
	char ch;
	struct termios old, new;

	tcgetattr (STDIN_FILENO, &old);
	memcpy (&new, &old, sizeof (struct termios));
	new.c_lflag &= ~(ICANON | ECHO);
	tcsetattr (STDIN_FILENO, TCSANOW, &new);
	i = read (STDIN_FILENO, &ch, 1);
	tcsetattr (STDIN_FILENO, TCSANOW, &old);

	assert(i == 1);
	return ch;
}

void show_cars()
{
	int counter = 0;
	int i; //counter

	printf("***Phoenix Car Park -- Park like a Prince(tm)***\n");


	for(i = 0; i < CAR_PARK_SIZE; i++)
	{
		if(carpark.buffer[i])
		{
			printf("Car %i :: %s -- parked in spot: %i\n", ++counter, carpark.buffer[i], i);
		}
	}
	printf("-----------\n");
	printf("%i car(s) in total, %i spot(s) free\n", counter, (CAR_PARK_SIZE - counter));
	printf("****************\n");

}

void *arrival(void *arg)
{
	int r;

	while(carpark.keep_running)
	{
		sleep_ms(TIME_OUT_SLEEP);			 //bed time!

		if(rand_i(1,100) > ARRIVAL_PERCENT_ACTION)
			continue; //haha, you fail. Go back and try again. lol.


		char* carName = new_car();

		add_car(carName);


	}

}

void *departure(void *arg)
{

	while(carpark.keep_running)
	{
		sleep_ms(TIME_OUT_SLEEP);

		if(rand_i(1,100) > DEPARTURE_PERCENT_ACTION)
			continue; //go back and try again

		remove_car();

	}

}

void *monitor(void *arg)
{
	char c;
	while(c = grabChar())
	{
		if(c == 'c' || c == 'C')
		{
			printf("<---- Key [%c] has been pressed ---->\n", c);
			show_cars();
		}
		else if(c == 'q' || c == 'Q')
		{
			printf("<---- Key [%c] has been pressed ---->\n", c);
			printf("<---- Quitting Program ---->\n");


			carpark.keep_running = 0;
			break;

		}
	}

}

void add_car(char *car)
{
	int availableSpot; //which carpark we'll park in

	sem_wait(&carpark.empty); //aquire empty
	pthread_mutex_lock(&carpark.mutex);

	//actual logic


	do
	{
		availableSpot = rand_i(0, CAR_PARK_SIZE-1);			//pick a carpark
	} while (carpark.buffer[availableSpot] != 0);    //is it full?

	carpark.buffer[availableSpot] = malloc(strlen(car) + 1);

	strcpy(carpark.buffer[availableSpot], car); //save a copy


	printf("%s: Car %s has arrived.\t(%i free)\n", theTime(), car, --carpark.size);


	//end logiz


	pthread_mutex_unlock(&carpark.mutex);
	sem_post(&carpark.full); //release full
}

void remove_car()
{
	int removeCar; //which car we'll remove

	sem_wait(&carpark.full); //aquire it
	pthread_mutex_lock(&carpark.mutex);

	//h'ok, this is easy

	do
	{
		removeCar = rand_i(0, CAR_PARK_SIZE-1);		//pick a carpark
	} while (carpark.buffer[removeCar] == 0);    //is it empty?

	printf("%s: Car %s has left.\t(%i free) \n", theTime(), carpark.buffer[removeCar], ++carpark.size);

	free(carpark.buffer[removeCar]);
	carpark.buffer[removeCar] = 0;


	pthread_mutex_unlock(&carpark.mutex);
	sem_post(&carpark.empty); //release empty

}
