#include "glutil.h"

typedef struct {GLfloat x, y, z;} GLpoint;

void getVector (GLpoint *pIn, GLpoint *pOffset, GLpoint *pOut)
{
	pOut->x = pIn->x - pOffset->x;
	pOut->y = pIn->y - pOffset->y;
	pOut->z = pIn->z - pOffset->z;
}

void getNormal (GLpoint *a, GLpoint *b, GLpoint *pOut)
{
   pOut->x = a->y * b->z - a->z * b->y;
   pOut->y = a->z * b->x - a->x * b->z;
   pOut->z = a->x * b->y - a->y * b->x;
}

int getFaceNormal (GLpoint *p1, GLpoint *p2, GLpoint *p3, GLpoint *pOut)
{
   GLpoint v1, v2;
   getVector(p1, p2, &v2);
   getVector(p3, p2, &v1);
   //GLpoint pn;
   getNormal(&v1, &v2, pOut);
   return (!(pOut->x == 0 && pOut->y == 0 && pOut->z == 0));
}

void setFaceNormal (GLfloat *p1, GLfloat *p2, GLfloat *p3)
{
	GLpoint pn;
	getFaceNormal((GLpoint*)p1, (GLpoint*)p2, (GLpoint*)p3, &pn);
	glNormal3f(pn.x, pn.y, pn.z);
}

void setMaterial (GLfloat *diffuse, GLfloat *specular, GLfloat shininess)
{  
  glMaterialfv(GL_FRONT, GL_DIFFUSE, diffuse);
  glMaterialfv(GL_FRONT, GL_SPECULAR, specular);
  glMaterialf(GL_FRONT, GL_SHININESS, shininess);
  glMaterialfv(GL_FRONT, GL_EMISSION, Black);
  glMaterialfv(GL_FRONT_AND_BACK, GL_AMBIENT, diffuse);
}
