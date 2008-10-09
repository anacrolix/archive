/*
A ncurses/gstreamer single-file audio player.

Developers: Eruanno (October 2008)
Code Review: Vaughan
Testing: Winter, Erikina, JDK/Endgame

Required libs: ncurses, glibc, gnomevfs, gstreamer
Gst-plugins: "playbin" element from gstreamer-plugins-base

The initial thread handles ncurses. A spawned thread handles the the pipeline(s)
and a glib mainloop. Stderr is directed to 'errlog' in the working directory.

A single URI or local file path is passed in as a parameter and played once.

After the intro screen, spacebar toggles play/pause, 'q' quits, and up and down
arrow keys change the volume.
*/

#include <string.h>

#include <curses.h>
#include <glib.h>

#include "audio.h"

static void print_song_line(
	WINDOW *win, int cols, char *fmt, ...)
{
	char line[cols + 1];
	memset(line, ' ', cols);
	line[cols] = '\0';

	va_list ap;
	va_start(ap, fmt);
	char *s = g_strdup_vprintf(fmt, ap);
	va_end(ap);

	int n = strlen(s);
	if (n < cols) {
		strncpy(&line[(cols - n) / 2], s, n);
		waddstr(win, line);
	} else {
		waddstr(win, s);
	}
	waddch(win, '\n');

	g_free(s);
}

void print_song(AudioPlayer ap, WINDOW *win, int rows, int cols)
{
	/* print audio sink name */
	mvwprintw(win, 0, 0, "audio-sink: %s", ap_sink_factory_name(ap));
	wclrtoeol(win);
	mvwprintw(win, 1, 0, "volume: %3.0f%%", ap_current_volume(ap));
	wclrtoeol(win);

	wmove(win, rows / 2 - 3, 0);

	/* print state */
	print_song_line(win, cols, "%s", ap_state_to_string(ap));

	/* print uri */
	print_song_line(win, cols, "%s", ap_current_uri(ap));

	/* print song tags */
#if 0
	gchar *artist = NULL, *album = NULL, *title = NULL;
	gst_tag_list_get_string(data->tags, GST_TAG_ARTIST, &artist);
	gst_tag_list_get_string(data->tags, GST_TAG_ALBUM, &album);
	gst_tag_list_get_string(data->tags, GST_TAG_TITLE, &title);
	print_song_line(win, cols, "%s / %s / %s", artist, album, title);
	g_free(artist); g_free(album); g_free(title);

	/* print song position/duration */
	GstFormat format = GST_FORMAT_TIME;
	gint64 position = 0, duration = 0;
	if (gst_element_query_position(data->pipe, &format, &position) &&
		format == GST_FORMAT_TIME &&
		gst_element_query_duration(data->pipe, &format, &duration) &&
		format == GST_FORMAT_TIME)
	{
		print_song_line(
			win, cols, "%lld:%02lld / %lld:%02lld",
			position / (60*E9), position / E9 % 60,
			duration / (60*E9), duration / E9 % 60);
	} else {
		print_song_line(win, cols, "ERROR QUERYING POSITION/DURATION");
	}
#endif

	wrefresh(win);
}

void main_menu(AudioPlayer ap)
{
	/* create play window with room for stdscr box */
	int playwin_rows = LINES - 2;
	int playwin_cols = COLS - 2;
	WINDOW *playwin = newwin(playwin_rows, playwin_cols, 1, 1);

	print_song(ap, playwin, playwin_rows, playwin_cols);

	g_assert(keypad(playwin, TRUE) == OK);
	noecho();
	halfdelay(1);
	while (TRUE) {
		int ch = wgetch(playwin);
		switch (ch) {
			case ' ': {
				ap_toggle_play(ap);
			}
			break;
			case 'q':
			goto quit;
			case KEY_UP:
				ap_volume_up(ap);
			break;
			case KEY_DOWN:
				ap_volume_down(ap);
			break;
			case KEY_RIGHT:
				ap_next_track(ap);
			break;
			case KEY_LEFT:
				ap_prev_track(ap);
			break;
			default:
				break;
		}
		print_song(ap, playwin, playwin_rows, playwin_cols);
	}
quit:
	delwin(playwin);
}

void intro_screen()
{
	char const greeting[] = "Welcome to Curstar!";
	mvprintw(LINES/2,(COLS-strlen(greeting))/2,"%s",greeting);
	refresh();
	//sleep(1);
}

/* converts relative or absolute input path to uri */
static gchar *input_to_uri(char *input)
{
	char const
		PROT_OP[] = "://",
		FILE_SCHEME[] = "file:///";
	/* try for valid file uri */
	if (!strncasecmp(input, FILE_SCHEME, strlen(FILE_SCHEME)))
		return strdup(input);
	/* find scheme operator */
	char const *op = input;
	while (isalpha(*op)) op++;
	if (!strncmp(op, PROT_OP, strlen(PROT_OP))) {
		return strdup(input);
	} else {
		if (input[0] == '/') {
			return g_strconcat("file://", input, NULL);
		} else {
			gchar *wd = g_get_current_dir();
			gchar *uri = g_strconcat("file://", wd, "/", input, NULL);
			g_free(wd);
			return uri;
		}
	}
}

/*
Recursively finds files and builds a double-linked list of their URIs.

TODO: Verify each addition is playable audio media.
*/
static GList *search_audio_files(gchar const *path, GList *files)
{
	//GError *err;
	GDir *dir = g_dir_open(path, 0, NULL);
	if (!dir) {
		/* found a file, just add for now */
		gchar *abs_path;
		if (g_path_is_absolute(path)) {
			abs_path = g_strdup(path);
		} else {
			gchar *work_dir = g_get_current_dir();
			abs_path = g_build_filename(work_dir, path, NULL);
			g_free(work_dir);
		}
		gchar *uri = g_strconcat("file://", abs_path, NULL);
		g_free(abs_path);
		files = g_list_prepend(files, uri);
	} else {
		gchar const *name;
		while ((name = g_dir_read_name(dir))) {
			gchar *new_path = g_build_filename(path, name, NULL);
			files = search_audio_files(new_path, files);
			g_free(new_path);
		}
		g_dir_close(dir);
	}
	return files;
}

int main(int argc, char *argv[])
{
	/* initialize gstreamer */
	gst_init(&argc, &argv);

	if (argc != 2) {
		/* TODO: will argv[1] work if gstreamer is passed args? */
		fprintf(stderr, "Usage: %s <URI>\n", g_get_prgname());
		return 1;
	}

	AudioPlayer ap = ap_new(g_list_reverse(search_audio_files(argv[1], NULL)));

	if (!ap_set_track(ap, 0)) {
		goto fail_audio;
	}

	/* redirect stderr so it doesn't shit all over the console */
	if (isatty(fileno(stderr))) {
		g_assert(freopen("errlog", "w", stderr));
	}

	/* initialize curses */
	initscr();

	box(stdscr, ACS_VLINE, ACS_HLINE);
	curs_set(0); /* this will break on unclean shutdown */
	intro_screen();

	main_menu(ap);

	endwin();

fail_audio:
	ap_free(ap);
	return 0;
}

