#define SWITCH_THRESH 10
#define START_TIME 0
#define STOP_TIME 1
#define MAX_PRINT 100
#define MAX_INTS 1000000000
#define MAX_THRDS 65
void init_data( int*, int, int );
void prtvec(int x[], int n, char* title);
void measure_time(int iparm, char* label);
void check_results(int* check_data, int* data, int N);
void radixsort(int *val, int N, int MxInt);
