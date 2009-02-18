#ifndef _utility_
#define _utility_

#include <math.h>
#ifndef M_PI
#define M_PI 3.14159265358979323846
#endif


typedef int	Boolean;
typedef char *	String;

#ifndef TRUE
#define TRUE	(1)
#define FALSE	(0)
#endif

extern void * New (int size);

extern void Fail (String message);
extern void FailNull (void * ptr, String source);
extern void FailErr (int code, String source);

extern double Radians (double degrees);
extern double Degrees (double radians);

#endif
