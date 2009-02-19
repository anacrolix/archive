
/****	Traditional first 3D program: spinning cube
Written by Hugh Fisher				****/

#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#include <GL/glut.h>

#include "utility.h"
#include "glUtils.h"

#define Near	 0.5
#define Far	20.0

#define ESC	  27

#define cmdRed		 1
#define cmdGreen	 2
#define cmdReverse	 3
#define cmdExit		99

static int	WinWidth, WinHeight;
static RGBA	CubeColor;
static int	AppMenu;
static GLfloat	Spin, Step = 0.5;
static GLfloat	ViewPoint[3];

/****		Cube in points-polygons (polyhedron) form	****/

static GLfloat Verts[8][3] = {
  { -0.5,  0.5, -0.5 }, /* 0 left top rear */
  {  0.5,  0.5, -0.5 },	/* 1 right top rear */
  {  0.5, -0.5, -0.5 },	/* 2 right bottom rear */
  { -0.5, -0.5, -0.5 },	/* 3 left bottom rear */
  { -0.5,  0.5,  0.5 },	/* 4 left top front */
  {  0.5,  0.5,  0.5 },	/* 5 right top front */
  {  0.5, -0.5,  0.5 },	/* 6 right bottom front */
  { -0.5, -0.5,  0.5 }	/* 7 left bottom front */
};

static GLuint Faces[] = {
  4, 5, 6, 7,	/* front */
  5, 1, 2, 6,	/* right */
  0, 4, 7, 3,	/* left */
  4, 0, 1, 5,	/* top */
  7, 6, 2, 3,	/* bottom */
  1, 0, 3, 2	/* rear */
};

static void drawCube ()
{
  int i;
  
  /* Draw cube in traditional OpenGL style */
  glBegin(GL_QUADS);
  for (i = 0; i < 6 * 4; i++)
	glVertex3fv(Verts[Faces[i]]);
  glEnd();
}

static void arrayCube ()
{
  /* Modern version using vertex arrays. Exactly the same effect
  as above, but only 2 OpenGL calls instead of 26. */
  
  /* Vertices are 3 floating point values each (XYZ), tightly
  packed in array. Array size is not specified nor checked!
  (Except by your program crashing if you get it wrong.) */
  glVertexPointer(3, GL_FLOAT, 0, Verts);
  
  /* Draw quads, using N vertices in total, in the order given
  by an array of ints, from the vertex array specified earlier. */
  glDrawElements(GL_QUADS, 6 * 4, GL_UNSIGNED_INT, Faces);
}


/****		Window events		****/

static void setProjection ()
{
  GLfloat aspect;
  
  glMatrixMode(GL_PROJECTION);
  glLoadIdentity();
  aspect = (float)WinWidth / (float)WinHeight;
  gluPerspective(60.0, aspect, Near, Far);
  /* Back to normal */
  glMatrixMode(GL_MODELVIEW);
}

static void setViewPoint ()
{
  glLoadIdentity();
  gluLookAt(ViewPoint[0], ViewPoint[1], ViewPoint[2],
			0.0, 0.0, 0.0,
			0.0, 1.0, 0.0);
}

static void drawWorld ()
{
  glPushMatrix();
  glRotatef(Spin, 0.0, 1.0, 0.0);
  glScalef(0.5, 0.5, 0.5);
  glColor3fv(CubeColor);
  drawCube();
  /* arrayCube() */
  glPopMatrix();
  
}

static void display ()
{
  glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
  
  setProjection();
  setViewPoint();
  drawWorld();
  
  /* Check everything OK and update screen */
  CheckGL();
  glutSwapBuffers();
}

static void resize (int width, int height)
{
  /* Save for event handlers */
  WinWidth  = width;
  WinHeight = height;
  
  /* Reset view in window. */
  glViewport(0, 0, WinWidth, WinHeight);
  printf("Window resized: (%d, %d)\n", WinWidth, WinHeight);
}


/****		User events		****/


static void menuChoice (int item)
{
  switch (item) {
	case cmdRed:
	  SetColor(CubeColor, 1, 0, 0);
	break;
	case cmdGreen:
	  SetColor(CubeColor, 0, 1, 0);
	break;
	case cmdReverse:
	  Step *= -1;
	break;
	case cmdExit:
	  exit(0);
	break;
	default:
	  break;
  }
}


/* In most GUI systems we would write just one event handler
for all kinds of keystrokes. In GLUT, we need one for the
standard ASCII keys and one for special cursor or function
style keys that vary from system to system. Because the
GLUT special key code range overlaps with ASCII lowercase,
it isn't safe to use the same function for both.        */

static void asciiKey (unsigned char key, int x, int y)
{
  if (key == ESC) {
	menuChoice(cmdExit);
  } else if (key == 'r' || key == 'R') {
	menuChoice(cmdReverse);
  } else {
	switch (key) {
	  case 'a':
		ViewPoint[0] -= 0.1; break;
	  case 's':
		ViewPoint[2] += 0.1; break;
	  case 'd':
		ViewPoint[0] += 0.1; break;
	  case 'w':
		ViewPoint[2] -= 0.1; break;
	}
  }
}

static void specialKey (int key, int x, int y)
{
  switch (key) {
	case GLUT_KEY_LEFT:
	  Step -= 0.1; break;
	case GLUT_KEY_RIGHT:
	  Step += 0.1; break;
  }
}


/****		Startup			****/

static void initGraphics (void)
{
  /* Black background */
  glClearColor(0, 0, 0, 0);
  /* Wireframe mode */
  glPolygonMode(GL_FRONT_AND_BACK, GL_LINE);
  
  /* Needed for vertex arrays */
  glEnableClientState(GL_VERTEX_ARRAY);
  
  /* Popup menu attached to right mouse button */
  AppMenu = glutCreateMenu(menuChoice);
  glutSetMenu(AppMenu);
  glutAddMenuEntry("Red", cmdRed);
  glutAddMenuEntry("Green", cmdGreen);
  glutAddMenuEntry("----", 0);
  glutAddMenuEntry("Reverse", cmdReverse);
  glutAddMenuEntry("----", 0);
  glutAddMenuEntry("Exit", cmdExit);
  glutAttachMenu(GLUT_RIGHT_BUTTON);
  
  /* Start values */
  Spin = 0.0;
  ViewPoint[0] = 0.0;
  ViewPoint[1] = 0.5;
  ViewPoint[2] = 2.0;
  
  menuChoice(cmdGreen);
}


/****		Main control		****/


static void spinDisplay (void)
{
  Spin += Step;
  if (Spin >= 360.0)
	Spin -= 360.0;
  glutPostRedisplay();
}

int main (int argc, char * argv[])
{
  glutInit(&argc, argv);
  glutInitDisplayMode(GLUT_DOUBLE | GLUT_DEPTH | GLUT_RGB);
  
  glutInitWindowSize(500, 500);
  glutInitWindowPosition(100, 75);
  glutCreateWindow("Cube");
  
  initGraphics();
  
  glutDisplayFunc(display);
  glutReshapeFunc(resize);
  
  glutKeyboardFunc(asciiKey);
  glutSpecialFunc(specialKey);
  
  glutIdleFunc(spinDisplay);
  
  glutMainLoop();
  /* Should never get here, but keeps compiler happy */
  return 0;
}
