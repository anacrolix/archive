#ifndef _texmap_
#define _texmap_

/****	Simple texture map creation and usage library.
	Relies on the simple image loader		****/


#include "glimage.h"

typedef struct {
	GLuint		ID;		/* OpenGL identifier */
	int		width, height;
	int		format, type;	/* OpenGL pixel data values */
	int		bpp;		/* Bytes per pixel */
	} Texmap;

/* Create empty texture map. 1 bpp = luminance, 3 = rgb, 4 = rgba */
extern void NewTexmap (Texmap * tex, int width, int height, int bpp);

/* Create from existing image */
extern void TexmapFromImage (Texmap * tex, GLImage * source);

/* Bind texture and set mode/wrap/filter parameters.
   mode: GL_DECAL ...
   wrap: GL_CLAMP, GL_REPEAT
   filter: GL_NEAREST, GL_LINEAR, ...
    */
extern void BindTexmap (Texmap * tex, GLint mode, GLint wrap, GLint filter);

#endif
