#include <GL/glut.h>
#include <stdlib.h>
#include <math.h>

static GLfloat viewPoint[3] = {0.0, -5.0, 0.0};

static unsigned int robotMode = 0;

static GLfloat 
	worldCycle = 0.0,
	jawAngle,
	turntableAngle,
	viewAltitude = 0.0,
	beaterAngle;
	
static GLUquadricObj *qobj;

static const GLfloat mandVerts[8][3] = {
	{0.25, 0.50, 0.40},
	{0.00, 0.00, 0.00},
	{2.25, 0.50, 0.40},
	{2.50, 0.00, 0.00},
	{2.25, 1.50, 0.40},
	{2.50, 2.00, 0.00},
	{0.25, 1.50, 0.40},
	{0.00, 2.00, 0.00}
};

void drawHandle ()
{
	int i;
	glPushMatrix();
		glTranslatef(0, 0, -0.5);
		//glColor3f(0.5, 0.5, 0.5);
		gluCylinder(qobj, 0.1, 0.1, 1.0, 12, 1);
		glTranslatef(0.0, 0.0, 1.0);
		if (robotMode) {
			glBegin (GL_LINES);
				glVertex3f(0.0, 0.0, 0.0);
				glVertex3f(0.0, 0.0, 1.0);
			glEnd ();
			for (i = 0; i < 4; i++) {
				glPushMatrix();
					glRotatef(90.0*i + beaterAngle, 0.0, 0.0, 1.0);
					glBegin(GL_LINE_STRIP);
						glVertex3f(0.0, 0.0, 0.5);
						glVertex3f(0.1, 0.0, 0.6);
						glVertex3f(0.1, 0.0, 0.9);
						glVertex3f(0.0, 0.0, 1.0);
					glEnd();
				glPopMatrix();
			}
		}
	glPopMatrix();
}

void drawMandible(int bottom) {
  int i;
  //draw main mandible
  glPushMatrix();
  	glTranslatef(-1.25, 0, 0);
		glBegin(GL_QUAD_STRIP);
			for (i = 0; i < 8; i++) glVertex3fv(&mandVerts[i][0]);
			glVertex3fv(&mandVerts[0][0]);
			glVertex3fv(&mandVerts[1][0]);  			
		glEnd();
		glBegin(GL_QUADS);
			glVertex3fv(&mandVerts[0][0]);
			glVertex3fv(&mandVerts[2][0]);
			glVertex3fv(&mandVerts[4][0]);
			glVertex3fv(&mandVerts[6][0]);
			/*
			glVertex3fv(&mandVerts[1][0]);
			glVertex3fv(&mandVerts[3][0]);
			glVertex3fv(&mandVerts[5][0]);
			glVertex3fv(&mandVerts[7][0]);  
			*/			
		glEnd();
	  if (bottom) {
	    //draw 7 teeth
	    if (robotMode) {
		    for (i = 1; i < 8; i++) {
		      glPushMatrix();
			      glTranslatef(i*0.3125, 2.0-3*0.05, 0.0);
			      glScalef(1.0, 1.0, -1.0);
			      glutWireCone(0.05, 0.1, 4, 3);
		      glPopMatrix();
		    }
		  }
	    //draw feet
	    glPushMatrix();
	    glTranslatef(0.45, 0.7, 0.4);
	    gluCylinder(qobj, 0.2, 0.2, 0.1, 8, 1);
	    glPopMatrix();
	    glPushMatrix();
	    glTranslatef(2.05, 0.7, 0.4);
	    gluCylinder(qobj, 0.2, 0.2, 0.1, 8, 1);
	    glPopMatrix();
	    glPushMatrix();
	    glTranslatef(0.35, 1.4, 0.4);
	    gluCylinder(qobj, 0.1, 0.1, 0.1, 8, 1);
	    glPopMatrix();
	    glPushMatrix();
	    glTranslatef(2.15, 1.4, 0.4);
	    gluCylinder(qobj, 0.1, 0.1, 0.1, 8, 1);
	    glPopMatrix();
	    //draw handles
	    glPushMatrix();
	    	glTranslatef(-0.1, 1.0, 0);
	    	glRotatef(90, -1.0, 0.0, 0.0);
	    	drawHandle();
	    glPopMatrix();
	    glPushMatrix();
	    	glTranslatef(2.6, 1.0, 0);
	    	glRotatef(90, -1.0, 0.0, 0.0);
	    	drawHandle();
	    glPopMatrix();
	  }
  glPopMatrix();
}

void drawGeorge(void)
{
  glPushMatrix();
  	glPushMatrix();
		  if (robotMode) glRotatef(jawAngle, 1.0, 0.0, 0.0);
		  drawMandible(0);
		glPopMatrix();
		glPushMatrix();
		  glScalef(1.0, 1.0, -1.0);
		  drawMandible(1);
  	glPopMatrix();
  glPopMatrix();
}

void drawTurntable(void)
{
	glPushMatrix();
		glTranslatef(0.0, -1.0, 0.0);
  	drawGeorge();
  glPopMatrix();
}

void drawWorld(void)
{
  glPushMatrix();
	  glRotatef(viewAltitude, 1.0, 0.0, 0.0);
	  glRotatef(turntableAngle, 0.0, 0.0, 1.0);
	  drawTurntable();
  glPopMatrix();
}		

void display(void)
{
  //clear buffer
  glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
  //set viewpoint
  glLoadIdentity();
  gluLookAt( // always look up the Y axis
  		viewPoint[0], viewPoint[1], viewPoint[2], 
	    viewPoint[0], viewPoint[1]+1.0, viewPoint[2], 
	    0.0, 0.0, 1.0);
  //draw wireframes
  glPolygonMode(GL_FRONT_AND_BACK, GL_LINE);
  glColor3f(1, 1, 1);
  drawWorld();
  //draw black faces
  glColor3f(0, 0, 0);
  glPolygonMode(GL_FRONT_AND_BACK, GL_FILL);
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
  case 'w':
  case 'W':
    viewPoint[1] += 0.5;
    break;
  case ' ':
  	if (robotMode) {
  		robotMode = 0;
  	} else {
  		robotMode = 1;
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

void init(void)
{
  qobj = gluNewQuadric();
  glEnable(GL_DEPTH_TEST);  
  glEnable(GL_POLYGON_OFFSET_FILL);
  glPolygonOffset(1.0, 2);  	
}

void idle(void)
{
	worldCycle += 0.01;
	if (worldCycle > 1.0) worldCycle -= 1.0;
	jawAngle = 30.0*fabsf(0.5-worldCycle);
  beaterAngle = 4.0*360.0*worldCycle;
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

