
/****	ASCII graphics emulator.
	Written by Hugh Fisher				****/

#include <stdio.h>
#include <ctype.h>
#include <stdlib.h>

#include <GL/glut.h>

#include "utility.h"
#include "glUtils.h"

#include "tty.h"

#define ESC		27

#define cmdClear	 1
#define cmdExit		99

#define TTYFont		GLUT_BITMAP_9_BY_15

static int AppMenu;


/****		Window events		****/


static void display ()
{
  int i, j, idx;
  
  glClear(GL_COLOR_BUFFER_BIT);

  /* Simple display with instant update.  */
  for (i = 0; i < ROWS; i++) {
    for (j = 0; j < COLS; j++) {
      glRasterPos2i(j, ROWS - i);
      glutBitmapCharacter(TTYFont, TTYBuffer[i][j]);
    }
  }
  /* 1D array version */
  /*int idx = 0; */
  /*for (int i = 0; i < TTY.ROWS; i++) { */
  /*  for (int j = 0; j < TTY.COLS; j++) { */
  /*    gl.glRasterPos2i(j, TTY.ROWS - i); */
  /*    glut.glutBitmapCharacter(gl, TTYFont, TTY.Buffer[idx]); */
  /*	idx += 1; */
  /*  } */
  /*} */
  
  /* Check everything OK and update screen */
  CheckGL();
  glutSwapBuffers();
}

static void resize (int width, int height)
{
  glMatrixMode(GL_PROJECTION);
  glLoadIdentity();
  gluOrtho2D(0, COLS, 0, ROWS);
  glViewport(0, 0, width, height);
  glMatrixMode(GL_MODELVIEW);
  glLoadIdentity();
}


/****		User events		****/


static void menuChoice (int item)
{
  switch (item) {
    case cmdClear:
      TTYClear();
      break;
    case cmdExit:
      exit(0);
      break;
    default:
      break;
  }
}


static void asciiKey (unsigned char key, int x, int y)
{
  key = toupper(key);
  
  if (key == ESC)
    menuChoice(cmdExit);
  else if (key == 'C')
    menuChoice(cmdClear);
  else if (key == 'V')
    /* Vertical line */
    TTYLine(10, 20, 10, 40, '*');
  else if (key == 'H')
    /* Horizontal */
    TTYLine(20, 50, 60, 50, '*');
  else if (key == 'R')
    /* Rectangle */
    TTYFill(20, 10, 40, 20, '*');
}


/****		Startup			****/

static void createWindow(char * title)
{
  int em;
  
  em = glutBitmapWidth(TTYFont, 'M');
  glutInitWindowSize(COLS * em, ROWS * em);
  glutInitWindowPosition(100, 75);
  glutCreateWindow("TTY");
}

static void initGraphics (void)
{
  glClearColor(0, 0, 0, 0);
  glColor3f(1,1,1);
  
  /* Popup menu attached to right mouse button */
  AppMenu = glutCreateMenu(menuChoice);
  glutSetMenu(AppMenu);
  glutAddMenuEntry("Clear", cmdClear);
  glutAddMenuEntry("----", 0);
  glutAddMenuEntry("Exit", cmdExit);
  glutAttachMenu(GLUT_RIGHT_BUTTON);
}


/****		Main control		****/

static void idle ()
{
  glutPostRedisplay();
}


int main (int argc, char * argv[])
{
  glutInit(&argc, argv);
  glutInitDisplayMode(GLUT_DOUBLE | GLUT_RGB);

  createWindow("TTY");
  initGraphics();
  
  TTYClear();
  
  glutDisplayFunc(display);
  glutReshapeFunc(resize);
  
  glutKeyboardFunc(asciiKey);
  
  glutIdleFunc(idle);
  
  glutMainLoop();
  /* Should never get here, but keeps compiler happy */
  return 0;
}
