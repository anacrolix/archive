#ifndef _TTY_
#define _TTY_

#define ROWS	60
#define COLS	80

/* Memory image of screen contents */
extern char TTYBuffer[ROWS][COLS];

/* Draw a line by inserting ch into TTYBuffer. Only
   horizontal or vertical lines are allowed, so x1 == x2
   or y1 == y2 */
extern void TTYLine (int x1, int y1, int x2, int y2, char ch);

/* Fill an area by inserting ch into TTYBuffer */
extern void TTYFill (int x, int y, int width, int height, char ch);

/* Clear the buffer */
extern void TTYClear ();

#endif
