#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <sys/time.h>
#include <unistd.h>
#include <pthread.h>
#include <string.h>
#include <errno.h>
#include <ctype.h>
#include <semaphore.h>
#include <termios.h>
#include <unistd.h>
#include <assert.h>


/* max number of cars the carpark can hold */
#define CAR_PARK_SIZE 10

/* prob of arrival of car */
#define ARRIVAL_PERCENT_ACTION 80

/* prob of departure of car */
#define DEPARTURE_PERCENT_ACTION 40

/* miliseconds to sleep between arrivals/departures */
#define TIME_OUT_SLEEP 1500



typedef struct {
    char *buffer[CAR_PARK_SIZE];    // stores carpark cars
    int  keep_running;		    // set false to exit threads
    int  size;			    // car parks left
	sem_t empty;
	sem_t full;
	pthread_mutex_t mutex;
} carpark;

carpark CarPark; //our global carpark

void *monitor(void *arg);
void *arrival(void *arg);
void *departure(void *arg);
void add_car(char *car);
void remove_car();
void show_cars();
char *new_car();
char* theTime();
char grabChar();
int rand_i(int min, int max);
int sleep_m(unsigned long milisec);


int sleep_m(unsigned long milisec)
{
    struct timespec req={0};
    time_t sec=(int)(milisec/1000);
    milisec=milisec-(sec*1000);
    req.tv_sec=sec;
    req.tv_nsec=milisec*1000000L;
    while(nanosleep(&req,&req)==-1)
         continue;
    return 1;
}



int main(int argc, char *argv[])
{
	srand( (unsigned int) time(NULL));

	CarPark.size = CAR_PARK_SIZE; //it's empty
	CarPark.keep_running = 1; //let it ruunn

	//Initialize the the locks
	pthread_mutex_init(&CarPark.mutex, NULL);
	sem_init(&CarPark.empty, 0, CAR_PARK_SIZE);
	sem_init(&CarPark.full, 0, 0);

	//Create the monitor thread (listens to the keyboard and does printing)..
	pthread_t tid;
	pthread_attr_t attr;
	pthread_attr_init(&attr);

	if(	pthread_create(&tid, &attr, monitor, NULL) )
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
	pthread_join(tid2, NULL);	
	pthread_join(tid3, NULL);

	return 0;
}

int rand_i(int min, int max)
{
	double denom = (RAND_MAX+1.0);
	double numer = (double)(max-min+1)*rand();

	int range = (int) (numer / denom);
	
	int ans = min + range;

	assert(ans >= min && ans <= max);

	return ans;

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
	
	t[strlen(t)-2] = ' '; //replace new line with space

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
		if(CarPark.buffer[i])
		{
			printf("Car %i :: %s -- parked in spot: %i\n", ++counter, CarPark.buffer[i], i);
		}
	}
	printf("-----------\n");
	printf("%i car(s) in total, %i spot(s) free\n", counter, (CAR_PARK_SIZE - counter));
	printf("****************\n");

}

void *arrival(void *arg)
{
	int r;

	while(CarPark.keep_running)
	{
		sleep_m(TIME_OUT_SLEEP);			 //bed time!

		if(rand_i(1,100) > ARRIVAL_PERCENT_ACTION)
			continue; //haha, you fail. Go back and try again. lol.
		
		
		char* carName = new_car();

		add_car(carName);


	}

}

void *departure(void *arg)
{

	while(CarPark.keep_running)
	{
		sleep_m(TIME_OUT_SLEEP);
		
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
			

			CarPark.keep_running = 0;
			break;

		}
	}

}

void add_car(char *car)
{
	int availableSpot; //which carpark we'll park in

	sem_wait(&CarPark.empty); //aquire empty
	pthread_mutex_lock(&CarPark.mutex);

	//actual logic


	do
	{
		availableSpot = rand_i(0, CAR_PARK_SIZE-1);			//pick a carpark
	} while (CarPark.buffer[availableSpot] != 0);    //is it full?

	CarPark.buffer[availableSpot] = malloc(strlen(car) + 1);

	strcpy(CarPark.buffer[availableSpot], car); //save a copy


	CarPark.size--;

	printf("%s: Car %s has arrived.\n", theTime(), car);


	//end logiz


	pthread_mutex_unlock(&CarPark.mutex);
	sem_post(&CarPark.full); //release full
}

void remove_car()
{
	int removeCar; //which car we'll remove

	sem_wait(&CarPark.full); //aquire it
	pthread_mutex_lock(&CarPark.mutex);

	//h'ok, this is easy

	do
	{
		removeCar = rand_i(0, CAR_PARK_SIZE-1);		//pick a carpark
	} while (CarPark.buffer[removeCar] == 0);    //is it empty?

	printf("%s Car %s has left.\n", theTime(), CarPark.buffer[removeCar]);

	free(CarPark.buffer[removeCar]);
	CarPark.buffer[removeCar] = 0;


	CarPark.size++;


	pthread_mutex_unlock(&CarPark.mutex);
	sem_post(&CarPark.empty); //release empty

}
