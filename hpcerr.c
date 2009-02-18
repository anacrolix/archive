#include <stdio.h>

typedef double REAL;

int main (void)
{
	REAL x,y,z,h;
	printf ("    Step       Numerical            Analytical           Absolute Error\n");
	h = (REAL) 0.1;
	x = (REAL) 1.23456789;
	while (h > 1.0e-15) {
		y = ((x+h)*(x+h)*(x+h) - x*x*x)/h;
		z = 3.0 * x * x;
		printf ("%10.2e %20.12e %20.12e %20.12e \n",h,y,z,y-z);
		h = h * 0.1;
	}
	return 0;
}


//    y = ((x+h)*(x+h)*(x+h) - (x-h)*(x-h)*(x-h))/(2.0*h);
