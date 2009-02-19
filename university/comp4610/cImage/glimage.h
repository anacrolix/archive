#ifndef _glimage_
#define _glimage_

#include <sys/types.h>

/****	Very simple image loading library.
	Accepts only Photoshop raw files or PPM/PGM binary	    ****/

typedef struct {
	int       width, height;
	int       format, type;	/* As required by glDrawPixels */
	int	  bpp;		/* Bytes per pixel */
	GLubyte * pixels;
	} GLImage;

/* Create an empty image */
extern void NewImage (GLImage * img, int width, int height, int bpp);

/* Create from raw Photoshop file */
extern void LoadRawImage (GLImage * img, String fileName,
				int width, int height, int bpp);

/* Create from PPM/PGM binary file */
extern void LoadPPMImage (GLImage * img, String fileName);

/* Get or set single pixel components. comp must be [img->bpp] */
extern void GetImagePixel (GLImage * img, int x, int y, int comp[]);
extern void SetImagePixel (GLImage * img, int x, int y, int comp[]);

#endif
