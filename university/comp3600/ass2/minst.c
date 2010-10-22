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

#ifdef NDEBUG
#   define verify(expr) ((void)(expr))
#else
#   define verify(expr) assert(expr)
#endif

static double random_weight()
{
    double rv = (double)(rand()+1)/((uintmax_t)RAND_MAX+2);
    assert(0.0 < rv && rv < 1.0);
    return rv;
}

#define LOG_DEBUG
#ifdef LOG_DEBUG
    __attribute__((format(gnu_printf, 1, 2)))
    static void log_debug(char const *fmt, ...)
    {
        va_list ap;
        va_start(ap, fmt);
        verify(0 <= vfprintf(stderr, fmt, ap));
        va_end(ap);
    }
#else
#   define log_debug(fmt, ...)
#endif

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
    for (size_t i = 0; i < n; ++i)
    {
        w[i][i] = 0;
        for (size_t j = i + 1; j < n; ++j)
            w[i][j] = w[j][i] = random_weight();
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
        pi[i] = -1;
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
                    size_t parent = (j + 1) / 2 - 1;
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
        if (pi[i] != -1) {
            log_debug("(%zu, %zu)=%04i, ", i, pi[i], (int)round(10000 * w[i][pi[i]]));
            total += w[i][pi[i]];
        }
    }
    log_debug("\n");
    return total;
}

int main(int argc, char **argv)
{
    log_debug("RAND_MAX=%u\n", RAND_MAX);
    log_debug("DBL_MAX=%e\n", DBL_MAX);

    unsigned int seed = time(NULL);
    unsigned repeats = 100;
    enum {
        HUMAN,
        TASK,
    } runmode = TASK;
    while (true)
    {
        int c = getopt_long(argc, argv, "hr:", (struct option []){
                {"human", no_argument, NULL, 'h'},
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
            exit(2);
        case 'h':
            runmode = HUMAN;
            break;
        case 'r':
            {
                char *endptr;
                repeats = strtol(optarg, &endptr, 10);
                if (*endptr != '\0') {
                    fprintf(stderr, "Error parsing repeats: %s", strerror(errno));
                    exit(2);
                }
            }
            break;
        }
    }
    if (optind < argc - 1) {
        fprintf(stderr, "Too many arguments given\n");
        exit(2);
    }
    else if (optind == argc - 1) {
        char *endptr;
        seed = strtol(argv[argc - 1], &endptr, 10);
        if (*endptr != '\0') {
            fprintf(stderr, "Error parsing seed: %s", strerror(errno));
            exit(2);
        }
    }

    srand(seed);
    switch (runmode)
    {
    case HUMAN:
        log_debug("minst weight=%f\n", minst_n(10));
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
