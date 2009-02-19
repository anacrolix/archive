#include <GL/glut.h>
#include <stdlib.h>
#include <math.h>

#include "robot.h"
#include "glutil.h"

static GLfloat	Ambient[] = { 0.2, 0.2, 0.2, 1.0 };

static GLfloat Diffuse[] = {0.8, 0.8, 0.8, 1.0};
static GLfloat Specular[] = {0.6, 0.6, 0.6, 1.0};

static GLfloat	LightPos[4] = { 5, 0, 5, 1 };

GLfloat viewPoint[3] = {0.0, -5.0, 0.0};
int mouseMenu;
GLfloat 
	worldCycle = 0.0,
	turntableAngle,
	viewAltitude = 0.0;	

void drawTurntable (void)
{
	glPushMatrix();
		glTranslatef(0.0, -1.0, 0.0);
  	drawGeorge();
  glPopMatrix();
}

void drawWorld (void)
{
  glPushMatrix();
	  glRotatef(viewAltitude, 1.0, 0.0, 0.0);
	  glRotatef(turntableAngle, 0.0, 0.0, 1.0);
	  drawTurntable();
  glPopMatrix();
}		

void defineLight (int n)
{
  glLightfv(GL_LIGHT0 + n, GL_AMBIENT, Ambient);  
  glLightfv(GL_LIGHT0 + n, GL_DIFFUSE, Diffuse);
  glLightfv(GL_LIGHT0 + n, GL_SPECULAR, Specular);
  glLightfv(GL_LIGHT0 + n, GL_POSITION, LightPos);
}

void display (void)
{
  //clear buffer
  glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
  //set viewpoint
  glLoadIdentity();
  
  defineLight(0);
  
  gluLookAt( // always look up the Y axis
  		viewPoint[0], viewPoint[1], viewPoint[2], 
	    viewPoint[0], viewPoint[1]+1.0, viewPoint[2], 
	    0.0, 0.0, 1.0);
  //draw black faces
  //glPolygonMode(GL_FRONT, GL_FILL);
  glColor3f(0, 0, 0);
  //defineMaterial();
  drawWorld();
  //update world
  glutSwapBuffers();
}

void reshape(int w, int h)
{
  glViewport (0, 0, (GLsizei)w, (GLsizei)h);
  glMatrixMode(GL_PROJECTION);
  glLoadIdentity();
  gluPerspective(60.0, (GLfloat)w/(GLfloat)h, 1.0, 30.0);
  glMatrixMode(GL_MODELVIEW);
}

void keyboard(unsigned char key, int x, int y)
{
  switch (key) {
  case 's':
  case 'S':
    viewPoint[1] -= 0.5;
    break;
  case 'L':
  case 'l':
  	LightPos[0] *= -1;
  	break;
  case 'w':
  case 'W':
    viewPoint[1] += 0.5;
    break;
  case ' ':
  	if (robotMode) {
  		robotMode = HARMLESS;
  	} else {
  		robotMode = BADASS;
  	}
  	break;
  case 27:
    exit(0);
    break;
  default:
    break;
  }
  glutPostRedisplay();
}

void special(int key, int x, int y)
{
  switch (key) {
  case GLUT_KEY_LEFT:
    turntableAngle += 5.0;
    break;
  case GLUT_KEY_RIGHT:
    turntableAngle -= 5.0;
    break;
  case GLUT_KEY_UP:
  	viewAltitude += 3.0;
  	if (viewAltitude > 90) viewAltitude = 90;
  	break;
  case GLUT_KEY_DOWN:
  	viewAltitude -= 3.0;
  	if (viewAltitude < -90) viewAltitude = -90; 
  	break;
  default:
    break;
  }
  glutPostRedisplay();
}

void menu (int option)
{
	switch (option) {
		case HARMLESS:
			robotMode = 1;
			break;
		case BADASS:
			robotMode = 0;
			break;
		default:
			break;
	}
}

void init(void)
{
	glClearColor(0, 0, 0, 0);
  qobj = gluNewQuadric();
  glEnable(GL_DEPTH_TEST);  
  glEnable(GL_LIGHTING);

  glEnable(GL_LIGHT0);
  glLightfv(GL_LIGHT0, GL_AMBIENT, Black);
  glLightfv(GL_LIGHT0, GL_DIFFUSE, Black);
  glLightfv(GL_LIGHT0, GL_SPECULAR, Black);
  glEnable(GL_NORMALIZE);
  //add mouse menu
  mouseMenu = glutCreateMenu(menu);
  glutSetMenu(mouseMenu);
  glutAddMenuEntry("Killer mode", HARMLESS);
  glutAddMenuEntry("Standard mode", BADASS);
  glutAttachMenu(GLUT_RIGHT_BUTTON);
}

void idle(void)
{
	worldCycle += 0.01;
	if (worldCycle > 1.0) worldCycle -= 1.0;
	jawAngle = 30.0*fabsf(0.5-worldCycle);
  beaterAngle = 2.0*360.0*worldCycle;
  glutPostRedisplay();	
}

int main(int argc, char** argv)
{
  glutInit(&argc, argv);
  glutInitDisplayMode(GLUT_DOUBLE | GLUT_RGB | GLUT_DEPTH);
  glutInitWindowSize(500, 500);
  glutCreateWindow("Killer George Foreman");
	
  init();
	
  glutReshapeFunc(reshape);
  glutKeyboardFunc(keyboard);
  glutSpecialFunc(special);
  glutDisplayFunc(display);
  glutIdleFunc(idle);
    
  glutMainLoop();
  return 0;
}

