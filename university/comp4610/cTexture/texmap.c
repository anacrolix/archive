
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#include <GL/glut.h>

#include "utility.h"
#include "glUtils.h"

#include "texmap.h"

void NewTexmap (Texmap * tex, int width, int height, int bpp)
{
  GLubyte * pixels;
  int	    bytes;
  
  /* OpenGL identifier */
  glGenTextures(1, &tex->ID);
  if (tex->ID == 0)
    Fail("Unable to allocate texture ID");
  
  /* Allocate image data */
  tex->width	= width;
  tex->height	= height;
  switch (bpp) {
    case 1:
    	tex->format = GL_LUMINANCE;
	break;
    case 3:
    	tex->format = GL_RGB;
	break;
    case 4:
    	tex->format = GL_RGBA;
	break;
    default:
    	Fail("Only 1,3,4 bpp allowed for NewTexmap");
  }
  tex->type = GL_UNSIGNED_BYTE;
  tex->bpp  = bpp;
  
  /* Initialise OpenGL */
  glBindTexture(GL_TEXTURE_2D, tex->ID);
  bytes = tex->width * tex->height * tex->bpp;
  pixels = New(bytes);
  memset(pixels, 0, bytes);
  glTexImage2D(GL_TEXTURE_2D, 0, tex->format,
  		tex->width, tex->height, 0,
		tex->format, tex->type, pixels);
  free(pixels);
}

void TexmapFromImage (Texmap * tex, GLImage * source)
{
  FailNull(source, "TexmapFromImage source image");
  
  /* This is slightly inefficient since the texture map
     will be initialised to all zero and then immediately
     updated, but we only do this once.    */
  NewTexmap(tex, source->width, source->height, source->bpp);
  
  glBindTexture(GL_TEXTURE_2D, tex->ID);
  glTexSubImage2D(GL_TEXTURE_2D, 0, 0, 0,
  		source->width, source->height,
		source->format, source->type,
		source->pixels);
}

void BindTexmap (Texmap * tex, GLint mode, GLint wrap, GLint filter)
{
  glBindTexture(GL_TEXTURE_2D, tex->ID);
  
  /* Tile or not */
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, wrap);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, wrap);

  /* Filtering. Magnification is more restricted than minification,
     so translate mipmap modes into equivalent simple mode */
  if (filter == GL_NEAREST || filter == GL_NEAREST_MIPMAP_NEAREST)
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
  else
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, filter);
  
  /* Render mode */
 glTexEnvf(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, mode);
}



