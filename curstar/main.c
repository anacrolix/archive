#include <curses.h>
#include <unistd.h>
#include <gst/gst.h>

int main(int argc, char *argv[])
{
	g_return_val_if_fail(initscr(), EXIT_FAILURE);
	mvprintw(11, 30, "%s", "Welcome to Curstar!");
	refresh();
	sleep(2);
	g_return_val_if_fail(endwin() == OK, EXIT_FAILURE);
	return EXIT_SUCCESS;
}
