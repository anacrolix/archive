
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include <math.h>

#include "utility.h"

void * New (int size)
{
  void * ptr;
  char   msg[256];
  
  ptr = calloc(1, size);
  if (ptr == NULL) {
    sprintf(msg, "Unable to allocate %d bytes in New", size);
    Fail(msg);
  }
  return ptr;
}

void Fail (String message)
{
  fprintf(stderr, "%s\n", message);
  exit(1);
}

void FailNull (void * ptr, String source)
{
  char msg[256];
  
  if (ptr == NULL) {
    sprintf(msg, "NULL pointer: %s", source);
    Fail(msg);
  }
}

void FailErr (int code, String source)
{
  char msg[256];
  
  if (code < 0) {
    if (errno == 0)
      sprintf(msg, "Error code %d: %s", code, source);
    else
      sprintf(msg, "Error code %d: %s", errno, source);
    Fail(msg);
  }
}

double Radians (double degrees)
{
  return degrees * M_PI / 180.0;
}

double Degrees (double radians)
{
  return radians * 180.0 / M_PI;
}
