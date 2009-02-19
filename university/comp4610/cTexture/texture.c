
/****	Written by Hugh Fisher to demonstrate texture mapping.
	Number #839 in the "rotating cube" series.
							****/

#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#include <GL/glut.h>

#include "utility.h"
#include "glUtils.h"

#include "glimage.h"
#include "texmap.h"

#define Near	 0.5
#define Far	20.0

#define ESC	  27

#define cmdRed		 1
#define cmdGreen	 2
#define cmdExit		99

static int	WinWidth, WinHeight;
static RGBA	CubeColor;
static int	AppMenu;
static GLfloat	Spin;

static Texmap	Brick;
static Texmap	Dice;

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

/* S,T texture coords for cube. This is also in indexed form,
   but we can't always use the same indexes as the geometry.
   As supplied every face uses the same coords: you will need
   to add new Tex entries and change TexFaces indexes. */

static GLfloat Tex[4][2] = {
  { 0.0, 0.0 },
  { 0.0, 1.0/3.0 },
  { 1.0/3.0, 1.0/3.0 },
  { 1.0/3.0, 0.0 }
};

static GLuint TexFaces[] = {
  1, 2, 3, 0,
  1, 2, 3, 0,
  1, 2, 3, 0,
  0, 1, 2, 3,
  0, 1, 2, 3,
  1, 2, 3, 0,
};


static void drawCube ()
{
  int i;
  
  glBegin(GL_QUADS);
    for (i = 0; i < 6 * 4; i++) {
      glTexCoord2fv(Tex[TexFaces[i]]);
      glVertex3fv(Verts[Faces[i]]);
    }
  glEnd();
}


/****		Window events		****/


static void display ()
{
  glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

  /* Establish viewpoint */
  glLoadIdentity();
  gluLookAt(0.0, 0.5, 2.0,
	    0.0, 0.0, 0.0,
	    0.0, 1.0, 0.0);
	    
  /* The 'world' */
  glPushMatrix();
    glRotatef(Spin, 0.0, 1.0, 0.0);
    glScalef(0.5, 0.5, 0.5);
    glColor3fv(CubeColor);
    BindTexmap(&Dice, GL_DECAL, GL_REPEAT, GL_LINEAR);
    drawCube();
  glPopMatrix();
  
  /* Check everything OK and update screen */
  CheckGL();
  glutSwapBuffers();
}

static void resize (int width, int height)
{
  GLfloat aspect;

  /* Save for mouse handlers */
  WinWidth  = width;
  WinHeight = height;
  
  /* Reset view in window. */
  glMatrixMode(GL_PROJECTION);
  glLoadIdentity();
  aspect = (float)width / (float)height;
  gluPerspective(60.0, aspect, Near, Far);
  glViewport(0, 0, width, height);
  /* Back to normal */
  glMatrixMode(GL_MODELVIEW);
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
    case cmdExit:
      exit(0);
      break;
    default:
      break;
  }
}

static void asciiKey (unsigned char key, int x, int y)
{
  if (key == ESC)
    menuChoice(cmdExit);
}

static void specialKey (int key, int x, int y)
{
}


/****		Startup			****/

static void initGraphics (void)
{
  GLImage src;
  
  glClearColor(0.0, 0.0, 0.0, 0.0);

  glEnable(GL_DEPTH_TEST);
  
  /* Needed for texture maps */
  glEnable(GL_TEXTURE_2D);
  
  /* Our texture maps */
  LoadPPMImage(&src, "bricks.pnm");
  TexmapFromImage(&Brick, &src);
  
  LoadPPMImage(&src, "dice.pnm");
  TexmapFromImage(&Dice, &src);
  
  AppMenu = glutCreateMenu(menuChoice);
  glutSetMenu(AppMenu);
  glutAddMenuEntry("Red", cmdRed);
  glutAddMenuEntry("Green", cmdGreen);
  glutAddMenuEntry("----", 0);
  glutAddMenuEntry("Exit", cmdExit);
  glutAttachMenu(GLUT_RIGHT_BUTTON);
  
  /* Start values */
  Spin = 0.0;
  menuChoice(cmdGreen);
}


/****		Main control		****/


static void spinDisplay (void)
{
  Spin += 2;
  if (Spin > 360.0)
    Spin -= 360.0;
  glutPostRedisplay();
}

int main (int argc, char * argv[])
{
  glutInit(&argc, argv);
  glutInitDisplayMode(GLUT_DOUBLE | GLUT_RGB | GLUT_DEPTH);

  glutInitWindowSize(500, 500);
  glutInitWindowPosition(100, 75);
  glutCreateWindow("Texture maps");

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
