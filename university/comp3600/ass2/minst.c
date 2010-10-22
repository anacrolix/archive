// Matt Joiner 2010
// Requires C99 and GCC-compatibility

#include <assert.h>
#include <errno.h>
#include <float.h>
#include <getopt.h>
#include <limits.h>
#include <math.h>
#include <stdarg.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <strings.h>
#include <time.h>

static enum {
    HUMAN,
    TASK,
} runmode = TASK;

#ifdef NDEBUG
#   define verify(expr) ((void)(expr))
#else
#   define verify(expr) assert(expr)
#endif

__attribute__((format(gnu_printf, 1, 2)))
static void log_debug(char const *fmt, ...)
{
    if (runmode != HUMAN)
        return;
    va_list ap;
    va_start(ap, fmt);
    verify(0 <= vfprintf(stderr, fmt, ap));
    va_end(ap);
}
//#define log_debug(...)

static double random_weight()
{
    double rv =
            //(double)(rand()+1)/((uintmax_t)RAND_MAX+2)
            (rand()+0.5)/(RAND_MAX+1.0)
        ;
    assert(0.0 < rv && rv < 1.0);
    return rv;
}

static size_t heap_parent(size_t i)
{
    size_t rv = (i + 1) / 2;
    assert(rv > 0);
    return rv - 1;
}

#ifndef NDEBUG
    static bool heap_valid(size_t len, size_t const heap[len], double const key[len])
    {
        for (size_t i = 1; i < len; ++i)
        {
            size_t parent = heap_parent(i);
            if (key[heap[parent]] > key[heap[i]])
                return false;
        }
        return true;
    }
#endif

double minst_n(unsigned const n)
{
    double w[n][n];
    {
        double rw_sum = 0.0;
        size_t rw_count = 0;
        for (size_t i = 0; i < n; ++i)
        {
            w[i][i] = 0;
            for (size_t j = i + 1; j < n; ++j) {
                double rw = random_weight();
                w[i][j] = rw;
                w[j][i] = rw;
                rw_sum += rw;
                rw_count += 1;
            }
        }
        log_debug("Average weight = %f, count = %zu\n", rw_sum / rw_count, rw_count);
    }
    for (size_t i = 0; i < n; ++i)
    {
        for (size_t j = 0; j < n; ++j)
            log_debug("%04i ", (int)round(10000 * w[i][j]));
        log_debug("\n");
    }
    double key[n];
    size_t pi[n];
    size_t q[n];
    size_t q_len = n;
    for (size_t i = 0; i < n; ++i)
    {
        key[i] = DBL_MAX;
        pi[i] = SSIZE_MAX;
        q[i] = i;
    }
    {
        size_t const r = rand() % n;
        log_debug("Picked r=%zu\n", r);
        key[r] = 0;
        q[0] = r;
        q[r] = 0;
    }
    while (q_len != 0)
    {
        assert(heap_valid(q_len, q, key));
        size_t const u = q[0];
        log_debug("Extracted u=%zu\n", u);
        /* EXTRACT-MIN(Q) */
        q[0] = q[q_len - 1];
        q_len -= 1;
        /* MAX-HEAPIFY(Q, 0) */
        for (size_t i = 0;;)
        {
            size_t const l = 2 * i + 1;
            size_t const r = 2 * i + 2;
            size_t smallest;
            if (l < q_len && key[q[l]] < key[q[i]])
                smallest = l;
            else
                smallest = i;
            if (r < q_len && key[q[r]] < key[q[smallest]])
                smallest = r;
            if (smallest != i) {
                size_t temp_z = q[i];
                q[i] = q[smallest];
                q[smallest] = temp_z;
                i = smallest;
            } else
                break;
        }
        for (size_t i = 1; i < q_len; ++i)
            assert(key[q[i]] >= key[q[0]]);
        if (q_len > 0) {
            for (size_t i = 0; i < q_len; ++i)
                log_debug("%zu=%04i ", q[i], (int)round(10000 * key[q[i]]));
            log_debug("\n");
        }
        for (size_t i = 0; i < q_len; ++i)
        {
            size_t v = q[i];
            if (w[u][v] < key[v]) {
                pi[v] = u;
                key[v] = w[u][v];
                for (size_t j = i; j > 0;)
                {
                    size_t parent = heap_parent(j);
                    if (key[q[parent]] > key[q[j]]) {
                        size_t temp_zu = q[parent];
                        q[parent] = q[j];
                        q[j] = temp_zu;
                        j = parent;
                    } else
                        break;
                }
            }
        }
    }
    double total = 0;
    for (size_t i = 0; i < n; ++i)
    {
        if (pi[i] != SSIZE_MAX) {
            log_debug("(%zu, %zu)=%04i, ", i, pi[i], (int)round(10000 * w[i][pi[i]]));
            total += w[i][pi[i]];
        }
    }
    log_debug("\n");
    return total;
}

static void print_usage()
{
    fprintf(stderr,
"\nUsage: minst [OPTIONS] [SEED=time()]\n"
"\n"
"Determine the average weights for minimum spanning tree of complete graphs with randomly weighted edges, seeded with SEED."
"\n"
"\n"
"OPTIONS\n"
"  -h, --human [GRAPHSIZE=5]\n"
"\tPrint debug statements for given graph of size GRAPHSIZE.\n"
"  -r, --repeat REPEATS=100\n"
"\tPerform REPEATS repeats instead of the default.\n"
"\n"
        );
}

int main(int argc, char **argv)
{
    unsigned int seed = time(NULL);
    unsigned human_n = 5;
    unsigned repeats = 100;
    while (true)
    {
        char *endptr;
        int c = getopt_long(argc, argv, "h::r:", (struct option []){
                {"human", optional_argument, NULL, 'h'},
                {"repeat", required_argument, NULL, 'r'},
                {NULL, 0, NULL, 0}},
            NULL);
        if (c == -1)
            break;
        switch (c)
        {
        default:
        case -1:
            fprintf(stderr, "Error parsing program arguments\n");
            print_usage();
            exit(2);
        case 'h':
            runmode = HUMAN;
            if (optarg) {
                human_n = strtol(optarg, &endptr, 10);
                if (*endptr != '\0') {
                    fprintf(stderr, "Error parsing graph size\n");
                    print_usage();
                    exit(2);
                }
            }
            break;
        case 'r':
            repeats = strtol(optarg, &endptr, 10);
            if (*endptr != '\0') {
                fprintf(stderr, "Error parsing repeats\n");
                print_usage();
                exit(2);
            }
            break;
        }
    }
    if (optind < argc - 1) {
        fprintf(stderr, "Too many arguments given\n");
        print_usage();
        exit(2);
    } else if (optind == argc - 1) {
        char *endptr;
        seed = strtol(argv[argc - 1], &endptr, 10);
        if (*endptr != '\0') {
            fprintf(stderr, "Error parsing seed\n");
            print_usage();
            exit(2);
        }
    } else
        assert(optind == argc);


    srand(seed);
    switch (runmode)
    {
    case HUMAN:
        log_debug("minst weight=%f\n", minst_n(human_n));
        break;
    case TASK:
        for (unsigned n = 20; n <= 100; n += 20)
        {
            double sum = 0.0;
            for (unsigned rpt = 0; rpt < repeats; ++rpt)
                sum += minst_n(n);
            printf("av(minst(%u), %u)=%f\n", n, repeats, sum / repeats);
        }
        break;
    default:
        exit(1);
    }
}

/*
Answers for Q2:

 *  if x fits inside y, and y fits inside z
    then
        for i in 1 to d
            x_i < y_(pi_1(i)) and y_i < z_(pi_2(i))
            then x_i < z_(pi_2(pi_1(i)))
    fi

 *  box_fit_other(x, y)
        if len(x) > len(y)
            return false
        min_heapify(x)
        min_heapify(y)
        while (len(x))
            if min_extract(x) >= min_extract(y)
                return false
        return true
*/
