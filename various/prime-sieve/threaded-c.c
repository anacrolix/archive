#include <pthread.h>
#include <glib.h>
#include <semaphore.h>
#include <stdlib.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdint.h>

typedef struct {
    pthread_mutex_t lock[1];
    GPtrArray *receivers;
    GPtrArray *senders;
    bool closed;
} Channel;

typedef enum {
    SUCCEEDED,
    CLOSED,
    BLOCKED,
} ChannelError;

typedef struct {
    void *item;
    pthread_cond_t cond[1];
    ChannelError status;
} ChannelWaiter;

Channel channel_create() {
    Channel ch[1];
    if (pthread_mutex_init(ch->lock, NULL)) abort();
    ch->receivers = g_ptr_array_new();
    ch->senders = g_ptr_array_new();
    ch->closed = false;
    return *ch;
}

ChannelWaiter channel_waiter_create()
{
    ChannelWaiter cw[1];
    if (pthread_cond_init(cw->cond, NULL)) abort();
    cw->status = BLOCKED;
    return *cw;
}

void channel_waiter_destroy(ChannelWaiter *cw)
{
    if (pthread_cond_destroy(cw->cond)) abort();
}

void channel_waiter_wait(ChannelWaiter *cw, pthread_mutex_t *mutex)
{
    cw->status = BLOCKED;
    while (cw->status == BLOCKED) {
        if (pthread_cond_wait(cw->cond, mutex)) abort();
    }
}

void channel_waiter_signal(ChannelWaiter *cw)
{
    if (pthread_cond_signal(cw->cond)) abort();
}

void channel_destroy(Channel *ch) {
    if (!ch->closed) abort();
    if (ch->receivers->len) abort();
    g_ptr_array_free(ch->receivers, TRUE);
    if (ch->senders->len) abort();
    g_ptr_array_free(ch->senders, TRUE);
    if (pthread_mutex_destroy(ch->lock)) abort();
}

void channel_free(Channel *ch) {
    channel_destroy(ch);
    free(ch);
}

static void close_waiters(GPtrArray *a)
{
    for (guint i = 0; i < a->len; ++i) {
        ChannelWaiter *w = g_ptr_array_index(a, i);
        w->status = CLOSED;
        channel_waiter_signal(w);
    }
    if (a->len) g_ptr_array_remove_range(a, 0, a->len);
}

void channel_close(Channel *ch)
{
    if (pthread_mutex_lock(ch->lock)) abort();
    ch->closed = true;
    close_waiters(ch->senders);
    close_waiters(ch->receivers);
    if (pthread_mutex_unlock(ch->lock)) abort();
}

Channel *channel_new() {
    Channel *ch = malloc(sizeof(Channel));
    *ch = channel_create();
    return ch;
}

ChannelError channel_send(Channel *ch, void *item)
{
    ChannelError err;
    if (pthread_mutex_lock(ch->lock)) abort();
    if (ch->closed) {
        err = CLOSED;
    } else if (ch->receivers->len) {
        ChannelWaiter *w = g_ptr_array_index(ch->receivers, 0);
        w->item = item;
        w->status = SUCCEEDED;
        channel_waiter_signal(w);
        g_ptr_array_remove_index_fast(ch->receivers, 0);
        err = SUCCEEDED;
    } else {
        ChannelWaiter w[1] = {channel_waiter_create()};
        w->item = item;
        g_ptr_array_add(ch->senders, w);
        channel_waiter_wait(w, ch->lock);
        err = w->status;
        channel_waiter_destroy(w);
    }
    if (pthread_mutex_unlock(ch->lock)) abort();
    return err;
}

ChannelError channel_recv(Channel *ch, void **value) {
    ChannelError err;
    if (pthread_mutex_lock(ch->lock)) abort();
    if (ch->closed) {
        err = CLOSED;
    } else if (ch->senders->len) {
        ChannelWaiter *w = g_ptr_array_index(ch->senders, 0);
        *value = w->item;
        w->status = SUCCEEDED;
        channel_waiter_signal(w);
        g_ptr_array_remove_index_fast(ch->senders, 0);
        err = SUCCEEDED;
    } else {
        ChannelWaiter w[1] = {channel_waiter_create()};
        g_ptr_array_add(ch->receivers, w);
        channel_waiter_wait(w, ch->lock);
        *value = w->item;
        err = w->status;
        channel_waiter_destroy(w);
    }
    if (pthread_mutex_unlock(ch->lock)) abort();
    return err;
}

typedef intptr_t Prime;

typedef struct {
    Prime max;
    Channel *out;
} GenerateArg;


void *generate(void *arg_) {
    GenerateArg *arg = arg_;
    Prime max = arg->max;
    Channel *out = arg->out;
    free(arg_);
    for (Prime i = 2; i <= max; ++i) {
        _Static_assert(sizeof(void *) >= sizeof i, "Prime too big");
        if (SUCCEEDED != channel_send(out, (void *)i)) abort();
    }
    channel_close(out);
    return NULL;
}

typedef struct {
    Channel *in, *out;
    Prime p;
} FilterArg;

void *filter(void *arg_) {
    FilterArg *arg = arg_;
    Channel *in = arg->in;
    Channel *out = arg->out;
    Prime p = arg->p;
    free(arg_);
    while (true) {
        Prime n;
        switch (channel_recv(in, (void **)&n)) {
            case SUCCEEDED:
            if (n % p) {
                if (SUCCEEDED != channel_send(out, (void *)n)) abort();
            }
            break;
            case CLOSED:
            channel_free(in);
            channel_close(out);
            return NULL;
            default:
            abort();
        }
    }
}

void sieve(Prime max) {
    Channel *ch = channel_new();
    GenerateArg *arg = malloc(sizeof *arg);
    *arg = (GenerateArg) {
        .max = max,
        .out = ch,
    };
    pthread_attr_t attr[1];
    if (pthread_attr_init(attr)) abort();
    if (pthread_attr_setdetachstate(attr, PTHREAD_CREATE_DETACHED)) abort();
    pthread_t thread[1];
    if (pthread_create(thread, attr, generate, arg)) abort();
    while (true) {
        Prime p;
        if (channel_recv(ch, (void **)&p) != SUCCEEDED) break;
        printf("%zi\n", p);
        Channel *ch1 = channel_new();
        FilterArg *arg = malloc(sizeof *arg);
        *arg = (FilterArg) {
            .in = ch,
            .out = ch1,
            .p = p,
        };
        if (pthread_create(thread, attr, filter, arg)) abort();
        ch = ch1;
    }
    channel_free(ch);
}


int main(int argc, char *argv[])
{
    sieve(atoi(argv[1]));
}
