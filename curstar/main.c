#include <curses.h>
#include <unistd.h>
#include <gst/gst.h>

static gpointer curses_stuff(gpointer data)
{
	initscr();
	box(stdscr, ACS_VLINE, ACS_HLINE);
	mvprintw(11, 30, "%s", "Welcome to Curstar!");
	refresh();
	sleep(2);
	endwin();
	g_idle_add(g_main_loop_quit, data);
}

int main(int argc, char *argv[])
{
	GThread *curses_thread;
	GMainLoop *main_loop;

	g_assert(argc == 2);

	gst_init(&argc, &argv);
	main_loop = g_main_loop_new(NULL, FALSE);
	curses_thread = g_thread_create(curses_stuff, main_loop, TRUE, NULL);

	g_main_loop_run(main_loop);

	g_thread_join(curses_thread);
	return EXIT_SUCCESS;
}
