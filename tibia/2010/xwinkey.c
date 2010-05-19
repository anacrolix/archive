#include <X11/Xlib.h>
#include <stdio.h>
#include <string.h>

Window window_with_name(
	Display *dpy, Window top, char *name)
{
	char *s;
	if (XFetchName(dpy, top, &s)) {
		if (!strcmp(s, name))
			return top;
	}
	Window root, parent;
	Window *childarr;
	int unsigned childlen;
	if (!XQueryTree(dpy, top, &root, &parent, &childarr, &childlen))
		return 0;
	Window retval = 0;
	for (int i = 0; i < childlen; ++i)
	{
		retval = window_with_name(dpy, childarr[i], name);
		if (retval)
			break;
	}
	XFree(childarr);
	return retval;
}

void send_key_event(Display *display, KeySym keysym)
{
	XKeyEvent event;
	memset(&event, 0, sizeof(event));
	event.type = KeyPress;
	event.keycode = XKeysymToKeycode(display, keysym);
	event.type = KeyRelease;
}

int main(int argc, char **argv)
{
	Display *display = XOpenDisplay(NULL);
	Window window = window_with_name(display, DefaultRootWindow(display), "Tibia Player Linux");
	printf("Tibia Window ID: 0x%08lx\n", window);
	for (int i = 1; i < argc; ++i)
	{
		KeySym keysym;
		char *key = strtok(argv[i], "+");
		while (key != NULL)
		{
			keysym = XStringToKeysym(key);
			send_key_event(display, keysym);
			key = strtok(NULL, "+");
		}
	}
	XCloseDisplay(display);
	return 0;
}
