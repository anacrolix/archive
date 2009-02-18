
/****	Program that demonstrates alpha blending and
	color adjustment in OpenGL.
	Hugh Fisher 2004				****/

#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#include <GL/glut.h>

#include "utility.h"
#include "glUtils.h"
#include "glimage.h"

#define Near	 0.5
#define Far	20.0

#define ESC	  27

#define cmdExit		99
static int	AppMenu;

static int	WinWidth, WinHeight;

static GLImage	Pic1, Pic2;


static void drawImage (GLImage * i, int x, int y)
{
  glWindowPos2i(x, y);
  glDrawPixels(i->width, i->height, i->format, i->type, i->pixels);
}


static void drawBlendedImages ()
{
  /* RGB images with alpha blending. First image is
     transferred unchanged, second blended over first */
  glDisable(GL_BLEND);
  drawImage(&Pic1, 64, WinHeight - 32);

  glEnable(GL_BLEND);
  glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
  glPixelTransferf(GL_ALPHA_SCALE, 0.0);
  drawImage(&Pic2, 64, WinHeight - 32);
}

static void drawImageChannels ()
{
  /* RGB image with channel selection */
  glColorMask(GL_TRUE, GL_TRUE, GL_TRUE, GL_TRUE);
  drawImage(&Pic1, 64, WinHeight - 32);
}

static void drawAdjustedImage ()
{
  /* RGB image with channel scaling and/or bias */
  glPixelTransferf(GL_RED_SCALE, 1.0);
  glPixelTransferf(GL_BLUE_BIAS, 0.0);
  
  drawImage(&Pic2, 64, WinHeight - 32);
}


/****		Window events		****/


static void display ()
{
  glClear(GL_COLOR_BUFFER_BIT);
  
  /* Save all GL state */
  glPushAttrib(GL_ALL_ATTRIB_BITS);

  drawBlendedImages();
  /* drawImageChannels(); */
  /* drawAdjustedImage(); */
  
  glPopAttrib();
  
  glutSwapBuffers();
  CheckGL();
}

static void resize (int width, int height)
{

  WinWidth  = width;
  WinHeight = height;

  /* Draw with pixel coords in 2D */
  glMatrixMode(GL_PROJECTION);
  glLoadIdentity();
  gluOrtho2D(0.0, (GLfloat)width, 0.0, (GLfloat)height);
  glViewport(0, 0, width, height);

  glMatrixMode(GL_MODELVIEW);
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
  // With no idle function generating updates, must
  // explicitly redraw if we want to see changes
  glutPostRedisplay();
}

static void asciiKey (unsigned char key, int x, int y)
{
  if (key == ESC)
    menuChoice(cmdExit);

  glutPostRedisplay();
}

static void specialKey (int key, int x, int y)
{
  glutPostRedisplay();
}


/****		Startup			****/


static void initImages ()
{
  /* All our images start at top left corner */
  glPixelZoom(1.0, -1.0);

  LoadRawImage(&Pic1, "s95_01407.rgb", 512, 512, 3);

  LoadRawImage(&Pic2, "s95_01408.rgb", 512, 512, 3);

}

static void initialise ()
{
  glClearColor(0.0, 0.0, 0.0, 0.0);

  AppMenu = glutCreateMenu(menuChoice);
  glutSetMenu(AppMenu);
  glutAddMenuEntry("----", 0);
  glutAddMenuEntry("Exit", cmdExit);
  glutAttachMenu(GLUT_RIGHT_BUTTON);

  initImages();

  CheckGL();
}


/****	Main program	****/


int main (int argc, char * argv[])
{
  glutInit(&argc, argv);

  glutInitDisplayMode(GLUT_DOUBLE | GLUT_RGBA);
  glutInitWindowSize(640, 576);
  glutInitWindowPosition(100, 75);
  glutCreateWindow("Image Manipulation");

  initialise();
  
  glutDisplayFunc(display);
  glutReshapeFunc(resize);
  glutKeyboardFunc(asciiKey);
  glutSpecialFunc(specialKey);

  glutMainLoop();
  return 0;
}
