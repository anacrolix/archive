
/*	Yet another spinning cube, this time with lighting.
	Written by Hugh Fisher 2004			*/

#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#include <GL/glut.h>

#include "utility.h"
#include "glUtils.h"

#define Near	 0.5
#define Far	20.0

#define ESC	  27

#define cmdLighting	1
#define cmdWireframe	2
#define cmdExit		99

static int	AppMenu;

static int	WinWidth, WinHeight;
static GLfloat	Spin;
static int	Animated;

static RGBA	CubeColor = { 0, 1, 0, 1 };

static RGBA	Ambient = { 0.05, 0.05, 0.05, 1.0 };

static RGBA Diffuse = {0.5, 0.5, 0.5, 1.0};

static RGBA Specular = {1.0, 1.0, 1.0, 1.0};

static GLfloat	LightPos[4] = { 1, 0, 1, 0 };

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


/* Surface normals for corresponding face of cube,
   to be filled in. */

static GLfloat Normals[6][3] = {
  { 0, 0, 1 },
  { 1, 0, 0 },
  { -1, 0, 0 },
  { 0, 1, 0 },
  { 0, -1, 0 },
  { 0, 0, -1 }
};


static void defineMaterial (RGBA diffuse, RGBA specular, float shininess)
{
  GLfloat shine[1];
  
  glMaterialfv(GL_FRONT_AND_BACK, GL_AMBIENT, diffuse);
  /* More calls... */
  
  shine[0] = shininess;
  glMaterialfv(GL_FRONT_AND_BACK, GL_SHININESS, shine);

  glMaterialfv(GL_FRONT_AND_BACK, GL_EMISSION, Black);
}

static void defineLight (int n)
{
  glLightfv(GL_LIGHT0 + n, GL_AMBIENT, Ambient);
  
  glLightfv(GL_LIGHT0 + n, GL_DIFFUSE, Diffuse);
  //glLightfv(GL_LIGHT0 + n, GL_SPECULAR, Specular);
  /* More calls... */
  
  glLightfv(GL_LIGHT0 + n, GL_POSITION, LightPos);
  
}

static void drawCube()
{
  int face, vert;
  
  glBegin(GL_QUADS);
  for (face = 0; face < 6; face++) {
     /* Define surface normal for this face */
     glNormal3fv(Normals[face]);
     /* Face vertices */
     for (vert = 0; vert < 4; vert ++)
      glVertex3fv(Verts[Faces[face * 4 + vert]]);
  }
  glEnd();
}

static void display ()
{
  glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

  glLoadIdentity();

  defineLight(0);

  gluLookAt(0, 0.5, 2,
	    0, 0, 0,
	    0, 1, 0);

  glPushMatrix();
  
    glRotatef(Spin, 0, 1, 0);
    glScalef(0.5, 0.5, 0.5);

    /* For shaded */
    defineMaterial(CubeColor, Black, 128);

    /* For wireframe */
    glColor3fv(CubeColor);

    //glutSolidCube(1);
    glutSolidSphere(0.5, 100, 100);

  glPopMatrix();
  
  CheckGL();
  glutSwapBuffers();
}

static void resize (int width, int height)
{
  GLfloat aspect;

  WinWidth  = width;
  WinHeight = height;
  
  glMatrixMode(GL_PROJECTION);
  glLoadIdentity();
  aspect = (float)width / (float)height;
  gluPerspective(60.0, aspect, Near, Far);
  glViewport(0, 0, width, height);
  glMatrixMode(GL_MODELVIEW);
}

/****		User events		****/


static void menuChoice (int item)
{
  switch (item) {
    case cmdLighting:
      glPolygonMode(GL_FRONT_AND_BACK, GL_FILL);
      glEnable(GL_LIGHTING);
      glutPostRedisplay();
      break;
    case cmdWireframe:
      glPolygonMode(GL_FRONT_AND_BACK, GL_LINE);
      glDisable(GL_LIGHTING);
      glutPostRedisplay();
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
  else if (key == ' ')
    Animated = ! Animated;
}


/****		Startup			****/


static void initGraphics (void)
{
  glClearColor(0, 0, 0, 0);

  glEnable(GL_DEPTH_TEST);

  glEnable(GL_LIGHT0);
  /* Don't use OpenGL defaults */
  glLightfv(GL_LIGHT0, GL_AMBIENT, Black);
  glLightfv(GL_LIGHT0, GL_DIFFUSE, Black);
  glLightfv(GL_LIGHT0, GL_SPECULAR, Black);
  
  /* Start with visible wireframe */
  menuChoice(cmdWireframe);

  /* If all your surface normals are normalised AND you never
     do any scaling, you don't need this call. Most programs do. */
  glEnable(GL_NORMALIZE);

  Animated = TRUE;
  Spin = 0;

  AppMenu = glutCreateMenu(menuChoice);
  glutSetMenu(AppMenu);
  glutAddMenuEntry("Lighting", cmdLighting);
  glutAddMenuEntry("Wire frame", cmdWireframe);
  glutAddMenuEntry("----", 0);
  glutAddMenuEntry("Exit", cmdExit);
  glutAttachMenu(GLUT_RIGHT_BUTTON);
}

/****		Main control		****/


static void spinDisplay (void)
{
  if (! Animated)
    return;

  Spin += 0.5;
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
  glutCreateWindow("Shaded Cube");

  initGraphics();
  
  glutDisplayFunc(display);
  glutReshapeFunc(resize);
  glutIdleFunc(spinDisplay);
  glutKeyboardFunc(asciiKey);
  
  glutMainLoop();
  return 0;
}
