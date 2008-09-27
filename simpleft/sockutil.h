#include <stdbool.h>
#include <sys/socket.h>

void *get_sockaddr_sinaddr(struct sockaddr *sa);
bool send_bytes(int const sock, void const *buf, size_t len);
