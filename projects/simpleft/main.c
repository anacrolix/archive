#include "include.h"
#include "client.h"
#include "server.h"

enum {
	SERVER,
	CLIENT,
} mode = -1;

char const **files = NULL;
char *host = NULL, *port = NULL;

bool do_options(int *argcp, char ***argvp);

int main(int argc, char *argv[])
{
	if (!do_options(&argc, &argv))
		return EXIT_FAILURE;

	switch (mode) {
	case CLIENT:
		do_client(host, port, files);
		break;
	case SERVER:
		do_server(port);
		break;
	}

	return EXIT_SUCCESS;
}

bool do_options(int *argcp, char ***argvp)
{
	assert(optind == 1); // getopt() is in initial state
	assert(!getenv("POSIXLY_CORRECT")); // allow opts & args to be mixed
	assert(opterr); // getopt() will write errors to stderr
	mode = CLIENT;
	int opt;
	while ((opt = getopt(*argcp, *argvp, "lp:h:")) != -1) {
		switch (opt) {
		case 'l':
			mode = SERVER;
			break;
		case 'p': {
			port = optarg;
			break;
		} case '?':
			return false;
		case 'h':
			host = optarg;
			break;
		default: assert(false);
		}
	}
	assert(optind <= *argcp);
	switch (mode) {
	case SERVER:
		assert(!host);
		if (optind < *argcp)
			fprintf(stderr, "server mode does not require file arguments\n");
		break;
	case CLIENT:
		files = &((*argvp)[optind]);
		assert(host);
#ifndef NDEBUG
		if (optind == *argcp) break;
		printf("files: ");
		while ((*argvp)[optind])
			printf("\"%s\", ", (*argvp)[optind++]);
		printf("\n");
#endif
		break;
	default: assert(false); break;
	}
	return true;
}
