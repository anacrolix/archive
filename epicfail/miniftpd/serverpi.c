#include "miniftpd.h"
#include "bytearray.h"

#define CMDTERM "\r\n"
#define CMDTRMSZ 2

ByteArray outbytes;
ByteArray inbytes;
char *username = NULL;
char *password = NULL;
int userpifd = 3;

void init_globals()
{
	outbytes = byte_array_new();
	inbytes = byte_array_new();
}

void push_response(char const *str)
{
	byte_array_push_string(outbytes, str);
	byte_array_push_string(outbytes, CMDTERM);
}

void handle_commands()
{
	char *endline;
	while ((endline = memmem(inbytes->buf, inbytes->size, CMDTERM, CMDTRMSZ)))
	{
		char const *command = inbytes->buf;
		size_t cmdsize = endline - command;
		char *cmdline = strrepr(command, cmdsize);
		my_log("<== %s", cmdline);
		free(cmdline);
		if (0 == strncasecmp(command, "user", 4)) {
			size_t namesize = endline - (command + 5);
			username = realloc(username, namesize + 1);
			strcpy(username, command + 5);
			push_response("331 Access granted.");
		}
		byte_array_shift(inbytes, cmdsize + CMDTRMSZ);
	}
	// we could check here that the buffer is not ridiculously big
}

void control_closed()
{
	my_log("Control connection closed!");
	exit(0);
}

int main()
{
	init_globals();
	log_new_process();
	push_response("220 Sup.");
	while (true)
	{
		fd_set readfds, writefds, excptfds;
		FD_ZERO(&readfds);
		FD_SET(userpifd, &readfds);
		FD_ZERO(&writefds);
		if (outbytes->size != 0)
			FD_SET(userpifd, &writefds);
		FD_ZERO(&excptfds);
		FD_SET(userpifd, &excptfds);
		expect(-1 != select(userpifd + 1, &readfds, &writefds, &excptfds, NULL));
		if (FD_ISSET(userpifd, &excptfds)) {
			my_log("userpi sock has exception");
		}
		if (FD_ISSET(userpifd, &writefds)) {
			ssize_t bytes = send(userpifd, outbytes->buf, outbytes->size, 0);
			require(bytes != -1);
			if (bytes > 0) {
				byte_array_shift(outbytes, bytes);
			}
		}
		if (FD_ISSET(userpifd, &readfds)) {
			char buf[0x100];
			ssize_t bytes = recv(userpifd, buf, sizeof(buf), 0);
			require(bytes != -1);
			if (bytes == 0)	{
				control_closed();
			}
			byte_array_push(inbytes, buf, bytes);
			handle_commands();
		}
	}
	return EXIT_SUCCESS;
}
