#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#include <GL/glut.h>

#include "utility.h"
#include "glUtils.h"

#define Near	0.5
#define Far		200.0

#define ESC	  	27

#define cmdExit	99

static int	WinWidth, WinHeight;
static RGBA
  	SunColor = {1.0, 1.0, 0},
    EarthColor = {0.0, 0.0, 0.5},
	MoonColor = {0.5, 0.5, 0.5},
	MarsColor = {1.0, 0.0, 0.0},
	MercuryColor = {1.0, 0.0, 0.0},
	VenusColor = {0.7, 0.0, 0.7};
static int	AppMenu;
static GLfloat	Day;
static GLfloat	ViewPoint[3];
static GLUquadricObj *Qplanet;

static void setProjection ()
{
  GLfloat aspect;
  glMatrixMode(GL_PROJECTION);
  glLoadIdentity();
  aspect = (float)WinWidth / (float)WinHeight;
  gluPerspective(60.0, aspect, Near, Far);
  glMatrixMode(GL_MODELVIEW);
}

static void setViewPoint ()
{
  glLoadIdentity();
  gluLookAt(ViewPoint[0], ViewPoint[1], ViewPoint[2],
	    0.0, 0.0, 0.0,
	    0.0, 0.0, 1.0);
}

static void drawPlanet (GLfloat radius, 
						GLfloat orbit, 
						GLfloat days, 
						RGBA color)
{
  glRotatef(Day*360.0/days, 0.0, 0.0, 1.0);
  glTranslatef(orbit, 0.0, 0.0);
  glColor3fv(color);
  gluSphere(Qplanet, radius, 10, 10);
}

static void drawWorld ()
{
  glPushMatrix();
  //sun
  glPushMatrix();
  drawPlanet(10, 0, 25*365, SunColor);
  glPopMatrix();
  //mercury
  glPushMatrix();
  drawPlanet(1, 15, 115, MercuryColor);
  glPopMatrix();
  //venus
  glPushMatrix();
  drawPlanet(2, 22, 583, VenusColor);
  glPopMatrix();
  //earth and moon
  glPushMatrix();
  drawPlanet(2, 30, 365, EarthColor);
  drawPlanet(1, 3, 28, MoonColor);
  glPopMatrix();
  //mars and moons
  glPushMatrix();
  drawPlanet(1.0, 50.0, 780.0, MarsColor);
  glPushMatrix();
  //drawPlanet(0.4, 1.5, 1, MoonColor);
  glPopMatrix();
  //~ glPushMatrix();
  //~ drawPlanet(0.2, 2, 1.3, MoonColor);
  //~ glPopMatrix();
  glPopMatrix();
  //jupiter  
  glPushMatrix();
  drawPlanet(5, 70, 4334, VenusColor);
  glPopMatrix();
  
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
}


/****		User events		****/


static void menuChoice (int item)
{
  switch (item) {
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
  if (key == ESC)
    menuChoice(cmdExit);
}

static void specialKey (int key, int x, int y)
{
  /* Nothing yet */
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
  glutAddMenuEntry("Exit", cmdExit);
  glutAttachMenu(GLUT_RIGHT_BUTTON);
  
  ViewPoint[0] = 0.0;
  ViewPoint[1] = 100.0;
  ViewPoint[2] = 50.0;
  
  Qplanet = gluNewQuadric();
  gluQuadricDrawStyle(Qplanet, GLU_LINE);
}

static void incDay (void)
{
  Day += 1;
  glutPostRedisplay();
}

int main (int argc, char * argv[])
{
  glutInit(&argc, argv);
  glutInitDisplayMode(GLUT_DOUBLE | GLUT_DEPTH | GLUT_RGB);

  glutInitWindowSize(500, 500);
  glutInitWindowPosition(100, 75);
  glutCreateWindow("Solar System");

  initGraphics();
  
  glutDisplayFunc(display);
  glutReshapeFunc(resize);
  
  glutKeyboardFunc(asciiKey);
  glutSpecialFunc(specialKey);
  
  glutIdleFunc(incDay);
  
  glutMainLoop();
  /* Should never get here, but keeps compiler happy */
  return 0;
}
