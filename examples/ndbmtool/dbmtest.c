#define _XOPEN_SOURCE

#include <assert.h>
#include <fcntl.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sysexits.h>
#include <unistd.h>

#include <ndbm.h>

enum dbm_mode { CREATE, EXCLUSIVE, TRUNCATE, OPEN };
enum datum_action { INSERT, REPLACE, FETCH, LIST, DELETE };

static void usage_and_quit(char const *problem)
{
	if (problem) fprintf(stderr, "%s\n\n", problem);
	/* TODO: replace <$0> with program invocation name */
	fprintf(stderr,
		"Usage: <$0> [-c|-x|-t] <db_path>\n"
		"\tDatum Action:\n"
		"\t-l\n"
		"\t(-i|-r) <key> <data>\n"
		"\t(-d|-f) <key>\n");
	exit(EX_USAGE);
}

static void parse_dbm_options(
	int *argc, char **argv[],
	enum dbm_mode *mode, char const **db_path)
{
	*mode = OPEN;
	if (optind < *argc && (*argv)[optind][0] == '-') {
		if (strlen((*argv)[optind]) > 2)
			goto fail_opt;
		switch ((*argv)[optind][1]) {
		case 'c':
			*mode = CREATE;
			break;
		case 'x':
			*mode = EXCLUSIVE;
			break;
		case 't':
			*mode = TRUNCATE;
			break;
		default:
			goto fail_opt;
		}
		optind++;
	}
	if (optind >= *argc || (*argv)[optind][0] == '-')
		goto fail_path;
	*db_path = (*argv)[optind++];
	return;
fail_opt:
	usage_and_quit("Unknown database option.");
fail_path:
	usage_and_quit("Missing database filename.");
}

static void key_from_opt(datum *key)
{
	key->dptr = optarg;
	key->dsize = strlen(optarg);
}

static void parse_datum_options(
	int *argc, char **argv[],
	enum datum_action *action, datum *key)
{
	*action = -1;
	int opt = getopt(*argc, *argv, "i:r:f:ld:");
	if (opt != -1) {
		switch (opt) {
		case 'i':
			*action = INSERT;
			key_from_opt(key);
			break;
		case 'r':
			*action = REPLACE;
			key_from_opt(key);
			break;
		case 'f':
			*action = FETCH;
			key_from_opt(key);
			break;
		case 'l':
			*action = LIST;
			*key = (datum){ .dptr = NULL, .dsize = 0 };
			break;
		case 'd':
			*action = DELETE;
			key_from_opt(key);
			break;
		default:
			usage_and_quit("Unknown datum action option.");
		}
	}
	if (*action == -1) {
		if (optind >= *argc) usage_and_quit("Key unspecified.");
		*action = INSERT;
		key->dptr = (*argv)[optind++];
		key->dsize = strlen(key->dptr);
	}
}

static void parse_data(
		int *argc, char **argv[],
		enum datum_action action, datum *data)
{
	switch (action) {
		case INSERT:
		case REPLACE:
			if (optind >= *argc)
				usage_and_quit("Data unspecified.");
			data->dptr = (*argv)[optind++];
			data->dsize = strlen(data->dptr);
			break;
		case FETCH:
		case LIST:
		case DELETE:
			*data = (__typeof(*data)){ .dptr = NULL, .dsize = 0 };
			break;
	}
}

static DBM *open_database(
	char const *path, enum dbm_mode mode, enum datum_action action)
{
	int flags;
	switch (action) {
	case INSERT:
	case REPLACE:
	case DELETE:
		/* dbm gets cranky if it doesn't get read perms */
		flags = O_RDWR;
		break;
	case FETCH:
	case LIST:
		flags = O_RDONLY;
		break;
	}
	switch (mode) {
	case CREATE:
		flags |= O_CREAT;
		break;
	case EXCLUSIVE:
		flags |= O_CREAT | O_EXCL;
		break;
	case TRUNCATE:
		flags |= O_TRUNC;
		break;
	case OPEN:
		break;
	}
	DBM *dbmp = dbm_open(path, flags, 0666);
	if (!dbmp) {
		/* bring the pain */
		perror("oh noes");
	}
	return dbmp;
}

static void print_key_value(datum key, datum value)
{
	/* provide max precision on NULL dptr's to get "(null)" */
	printf("key (%d bytes): %.*s, data (%d bytes):\n%.*s\nEOF\n",
			key.dsize, key.dsize ?: -1, key.dptr,
			value.dsize, value.dsize ?: -1, value.dptr);
}

static int do_action(
	DBM *dbmp, enum datum_action action,
	datum *key, datum *data)
{
	switch (action) {
	case INSERT: {
		int ret_i = dbm_store(dbmp, *key, *data, DBM_INSERT);
		if (ret_i == 1)
			fputs("Key already exists!\n", stderr);
		if (ret_i) goto fail;
		break;
	}
	case REPLACE:
		if (dbm_store(dbmp, *key, *data, DBM_REPLACE))
			goto fail;
		break;
	case DELETE:
		if (dbm_delete(dbmp, *key))
			goto fail;
		break;
	case FETCH:
		*data = dbm_fetch(dbmp, *key);
		if (!data->dptr)
			fputs("Key not found!\n", stderr);
		else
			print_key_value(*key, *data);
		break;
	case LIST:
		for (*key = dbm_firstkey(dbmp); key->dptr; *key = dbm_nextkey(dbmp)) {
			*data = dbm_fetch(dbmp, *key);
			assert(data->dptr);
			print_key_value(*key, *data);
		}
		break;
	}
	return true;
fail:
	return false;
}

int main(int argc, char *argv[])
{
	enum dbm_mode mode;
	char const *db_path;
	enum datum_action action;
	datum key, data;
	
	parse_dbm_options(&argc, &argv, &mode, &db_path);
	parse_datum_options(&argc, &argv, &action, &key);
	parse_data(&argc, &argv, action, &data);		
	if (optind < argc) usage_and_quit("Too many arguments given.");	

#ifndef NDEBUG
	print_key_value(key, data);
#endif

	DBM *dbmp = open_database(db_path, mode, action);
	if (!dbmp) return EXIT_FAILURE;
	
	int ret = do_action(dbmp, action, &key, &data);
	
	dbm_close(dbmp);	
	return ret;
}

