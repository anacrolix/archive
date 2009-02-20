// used for errno program_invocation_*_name extensions
#define _GNU_SOURCE

#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <errno.h>

//double ncdf(double);

int main(int argc, char *argv[])
{
	if (argc != 2) goto usage;
	char *endptr;
	double iq = strtod(argv[1], &endptr);
	if (iq == 0. && endptr == argv[1]) {
		printf("Invalid IQ specified!\n");
		goto fail;
	}
	/* IQ standard deviation is 16 */
	double dev = (iq - 100.) / 16.;
	/* erf(dev / sqrt(2.)) is the chance something is within the given standard deviations (both ends); double the odds because we only want the positive deviations (smarter than) */
	double chance = 2. / (1. - erf(dev / sqrt(2.)));
	printf("IQ: %f, stdev: %f, chance: 1 in %f\n",
		iq, dev, chance);
done:
	return EXIT_SUCCESS;
usage:
	printf("Usage: %s <IQ>\n", program_invocation_short_name);
fail:
	return EXIT_FAILURE;
}

/// normal cumulative distribution function
/* this could potentially be used for determining the probablity of ranges of IQs based on phi(stdev)-phi(-stdev) == erf(n/sqrt(2))? see http://en.wikipedia.org/wiki/Normal_distribution#Standard_deviation_and_confidence_intervals for more info */
/* this function not currently used */
#if 0
double ncdf(double x)
{
	// http://en.wikipedia.org/wiki/Error_function#Related_functions
	return .5 * (1 + erf(x / sqrt(2)));
}
#endif
