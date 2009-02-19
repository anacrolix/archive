#ifndef _robot_
#define _robot_

enum {HARMLESS, BADASS} robotMode;

extern GLfloat
	beaterAngle,
	jawAngle;

extern GLUquadricObj *qobj;

extern void drawGeorge (void);

#endif
