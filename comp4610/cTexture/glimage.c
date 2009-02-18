
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <GL/glut.h>

#include "utility.h"
#include "glUtils.h"

#include "glimage.h"


void NewImage (GLImage * img, int width, int height, int bpp)
{
  int bytes;
  
  if (width <= 0 || height <= 0)
    Fail("Bad width or height in NewImage");
  
  img->width  = width;
  img->height = height;
  switch (bpp) {
    case 1:
    	img->format = GL_LUMINANCE;
	break;
    case 3:
    	img->format = GL_RGB;
	break;
    case 4:
    	img->format = GL_RGBA;
	break;
    default:
    	Fail("Only 1,3,4 bytesPerPixel allowed for NewImage");
  }
  img->type = GL_UNSIGNED_BYTE;
  img->bpp  = bpp;
  bytes = width * height * bpp;
  img->pixels = (GLubyte *)New(bytes);
  memset(img->pixels, 0, bytes);
}


/****		File IO			****/


void LoadRawImage (GLImage * img, String fileName,
				int width, int height, int bpp)
{
  FILE * f;
  int	 size, target;
  char	 msg[256];

  /* Initialise */
  NewImage(img, width, height, bpp);
  
  /* File? */
  f = fopen(fileName, "rb");
  if (f == NULL) {
    sprintf(msg, "LoadRawImage: cannot open image file %s", fileName);
    Fail(msg);
  }

  /* File is right size? */
  target = img->width * img->height * img->bpp;
  FailErr(fseek(f, 0, SEEK_END), "LoadRawImage: fseek");
  size = ftell(f);
  if (size < target) {
    sprintf("LoadRawImage: %s must be %d bytes but only %d in file",
			  fileName, target, size);
    Fail(msg);
  }
  
  /* Load contents */
  FailErr(fseek(f, 0, SEEK_SET), "LoadRawImage: fseek");
  FailErr(fread(img->pixels, 1, target, f), "LoadRawImage: fread");
  fclose(f);
		
  printf("Loaded raw image from %s\n", fileName);
}

void LoadPPMImage (GLImage * img, String fileName)
{
  FILE * f;
  int	 w, h, max, bpp;
  char	 msg[256];
  char	 head[3];
  int	 target, count;

  /* File? */
  f = fopen(fileName, "rb");
  if (f == NULL) {
    sprintf(msg, "LoadPPMImage: cannot open image file %s", fileName);
    Fail(msg);
  }

  /* Header OK? */
  head[2] = 0;
  fscanf(f, "%c%c %d %d %d\n", &head[0], &head[1], &w, &h, &max);
  if (! strcmp(head, "P6") && ! strcmp(head, "P5"))
    Fail("LoadPPMImage can only read binary PPM or PGM format");
  else if (max > 255)
    Fail("LoadPPMImage cannot handle PPM/PGM max > 255 format");
    
  /* Initialise */
  if (strcmp(head, "P5") == 0)	/* Grayscale */
    bpp = 1;
  else
    bpp = 3;
  NewImage(img, w, h, bpp);
  
  target = w * h * bpp;
  count  = fread(img->pixels, 1, target, f);
  FailErr(count, "LoadPPMImage: fread");
  if (count < target) {
    sprintf("LoadPPMImage: %s must be %d bytes but only %d in file",
			  fileName, target, count);
    Fail(msg);
  }
  
  fclose(f);
		
  printf("Loaded PPM image from %s\n", fileName);
}


/****		Single pixel access/update		****/


void GetImagePixel (GLImage * img, int x, int y, int comp[])
{
  int base, i;
  
  if (x < 0 || x >= img->width || y < 0 || y >= img->height)
    Fail("GetImagePixel: x,y coords out of range");
    
  base = (y * img->height + x) * img->bpp;
  for (i = 0; i < img->bpp; i++)
    comp[i] = img->pixels[base + i];
}

void SetImagePixel (GLImage * img, int x, int y, int comp[])
{
  int base, i;
  
  if (x < 0 || x >= img->width || y < 0 || y >= img->height)
    Fail("SetImagePixel: x,y coords out of range");
    
  base = (y * img->height + x) * img->bpp;
  for (i = 0; i < img->bpp; i++)
    img->pixels[base + i] = comp[i];
}


