#ifndef _glutil_
#define _glutil_

#include <GL/glut.h>

static const GLfloat Black[] = { 0, 0, 0, 1 };

extern void setFaceNormal (GLfloat *p1, GLfloat *p2, GLfloat *p3);
extern void setMaterial (GLfloat *diffuse, GLfloat *specular, GLfloat shininess);

#endif
