#include <assert.h>
#include <float.h>
#include <limits.h>
#include <math.h>
#include <stdarg.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
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

__attribute__((format(gnu_printf, 1, 2)))
static void log_debug(char const *fmt, ...)
{
    va_list ap;
    va_start(ap, fmt);
    verify(0 <= vfprintf(stderr, fmt, ap));
    va_end(ap);
}

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
        for (size_t i = 1; i < q_len; ++i)
            assert(key[q[i]] >= key[q[0]]);
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

int main(void)
{
    log_debug("RAND_MAX=%u\n", RAND_MAX);
    log_debug("DBL_MAX=%e\n", DBL_MAX);
    //srand(1)
    srand(time(NULL));
    log_debug("minst weight=%f\n", minst_n(5));
    //for (unsigned n = 20; n <= 100; n += 20)
    //    minst_n(n);
}
