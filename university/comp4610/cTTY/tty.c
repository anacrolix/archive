
#include <GL/glut.h>

#include "tty.h"

char TTYBuffer[ROWS][COLS];


void TTYLine (int x1, int y1, int x2, int y2, char ch)
{
  int i, j;
  
  /* Your code here */
}

void TTYFill (int x, int y, int width, int height, char ch)
{
  int i, j;
  
  /* Your code here */
}

void TTYClear ()
{
  int i, j;
  
  for (i = 0; i < ROWS; i++)
    for (j = 0; j < COLS; j++)
      TTYBuffer[i][j] = ' ';
}

