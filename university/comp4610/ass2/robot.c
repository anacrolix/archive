#include <GL/glut.h>

#include "robot.h"
#include "glutil.h"

GLfloat
	beaterAngle,
	jawAngle;

GLUquadricObj *qobj;

GLfloat mandVerts[8][3] = {
	{0.25, 0.50, 0.40},
	{0.00, 0.00, 0.00},
	{2.25, 0.50, 0.40},
	{2.50, 0.00, 0.00},
	{2.25, 1.50, 0.40},
	{2.50, 2.00, 0.00},
	{0.25, 1.50, 0.40},
	{0.00, 2.00, 0.00}
};

int mandFaces[6][4] = {
	{0, 2, 4, 6},
	{0, 1, 3, 2},
	{2, 3, 5, 4},
	{4, 5, 7, 6},
	{6, 7, 1, 0},
	{1, 7, 5, 3},
};

/* 
	mandible is coloured metal
	teeth are dull metal
	handles are plastic
*/

GLfloat 
	mandUpperDiffuse[4] = {0.3, 0.3, 0.4, 1.0},
	mandLowerDiffuse[4] = {0.3, 0.3, 0.2, 1.0},
	mandUpperSpecular[4] = {0.6, 0.6, 0.7, 1.0},
	mandLowerSpecular[4] = {0.7, 0.7, 0.6, 1.0},
	//mandAmbient[4] = {0, 0, 0, 0},
	mandShininess = 64,
	teethDiffuse[4] = {0.6, 0.2, 0.2, 1.0},
	plasticDiffuse[4] = {0.2, 0.4, 0.2, 1.0},
	plasticSpecular[4] = {0.9, 0.9, 0.9, 1.0},
	plasticShininess = 96,
	beaterDiffuse[4] = {0.4, 0.4, 0.4, 1},
	beaterSpecular[4] = {0.8, 0.8, 0.8, 1},
	beaterShininess = 128;

void drawHandle ()
{
	int i;
	glPushMatrix();
		glTranslatef(0, 0, -0.5);
		setMaterial(plasticDiffuse, plasticSpecular, plasticShininess);
		gluCylinder(qobj, 0.1, 0.1, 1.0, 12, 1);
		glTranslatef(0.0, 0.0, 1.0);
		if (robotMode == BADASS) {
			setMaterial(beaterDiffuse, beaterSpecular, beaterShininess);
			//glColor3f(0.8, 0.8, 0.8);
			gluCylinder(qobj, 0.02, 0.02, 1.0, 12, 1);
			for (i = 0; i < 4; i++) {
				glPushMatrix();
					glTranslatef(0, 0, 0.5);
					glRotatef(90.0*i + beaterAngle, 0.0, 0.0, 1.0);
					/*
					glBegin(GL_LINE_STRIP);
						glVertex3f(0.0, 0.0, 0.5);
						glVertex3f(0.1, 0.0, 0.6);
						glVertex3f(0.1, 0.0, 0.9);
						glVertex3f(0.0, 0.0, 1.0);
					glEnd();
					*/
					glPushMatrix();
						glTranslatef(0.1, 0.0, 0.1);
						gluCylinder(qobj, 0.01, 0.01, 0.3, 12, 1);
					glPopMatrix();
					glPushMatrix();
						glRotatef(45, 0, 1, 0);
						gluCylinder(qobj, 0.01, 0.01, 0.1*sqrtf(2), 12, 1);
					glPopMatrix();
					glPushMatrix();
						glTranslatef(0.1, 0, 0.4);
						glRotatef(-45, 0, 1, 0);
						gluCylinder(qobj, 0.01, 0.01, 0.1*sqrtf(2), 12, 1);
					glPopMatrix();
				glPopMatrix();
			}
		}
	glPopMatrix();
}

void drawMandible(int bottom) {
  int i, j;
  //draw main mandible
  glPushMatrix();
  	glTranslatef(-1.25, 0, 0);
		
		glBegin(GL_QUADS);
			setMaterial(
				(bottom) ? mandLowerDiffuse : mandUpperDiffuse,
				(bottom) ? mandLowerSpecular : mandUpperSpecular, 
				mandShininess);
			//dont draw the last face for the upper mandible (roof of mouth)
			for (i = 0; i < (bottom ? 6 : 5); i++) {
				setFaceNormal(
					(GLfloat*)&mandVerts[mandFaces[i][0]],
					&mandVerts[mandFaces[i][1]],
					&mandVerts[mandFaces[i][2]]);
				for (j = 0; j < 4; j++)
					glVertex3fv(&mandVerts[mandFaces[i][j]]);
			}
		glEnd();
		glColor3f(1.0, 1.0, 1.0);
	  if (bottom) {
	    //draw 7 teeth
	    if (robotMode == BADASS) {
	    	setMaterial(teethDiffuse, Black, 0);
		    for (i = 1; i < 8; i++) {
		      glPushMatrix();
			      glTranslatef(i*0.3125, 2.0-3*0.05, 0.0);
			      glScalef(1.0, 1.0, -1.0);
			      glutSolidCone(0.05, 0.1, 4, 3);
		      glPopMatrix();
		    }
		  }
	    //draw feet
	    setMaterial(plasticDiffuse, plasticSpecular, plasticShininess);
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

void drawGeorge (void)
{
  glPushMatrix();
  	glPushMatrix();
		  if (robotMode == BADASS) glRotatef(jawAngle, 1.0, 0.0, 0.0);
		  drawMandible(0);
		glPopMatrix();
		glPushMatrix();
		  glScalef(1.0, 1.0, -1.0);
		  drawMandible(1);
  	glPopMatrix();
  glPopMatrix();
}
