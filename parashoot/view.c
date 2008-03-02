#include <math.h>
#include "SDL/SDL.h"
#include "SDL/SDL_image.h"
#include "model.h"
#include "error.h"

#define M_PI		3.14159265358979323846

SDL_Surface
	*screen,
	*bunker,
	*barrel;
//int fullscreen = 0;

SDL_Surface *loadImage(const char *file)
{
	SDL_Surface *originalImage = IMG_Load(file);
	if (!originalImage) return originalImage;
	SDL_Surface *optimizedImage = SDL_DisplayFormat(originalImage);
	SDL_Surface *chosenImage = NULL;
	if (optimizedImage) {
		chosenImage = optimizedImage;
		SDL_FreeSurface(originalImage);
	} else {
		chosenImage = originalImage;
		warn(SDL_GetError());
	}
	SDL_SetColorKey(optimizedImage, SDL_SRCCOLORKEY,
		SDL_MapRGB(optimizedImage->format, 0xFF, 0xFF, 0xFF));
	return chosenImage;
}

void initView()
{
	screen = SDL_SetVideoMode(800, 600, 32, SDL_SWSURFACE);
	if (!screen) fatal(SDL_GetError());
	SDL_WM_SetCaption("Parashoot", NULL);
	bunker = loadImage("bunker.png");
	barrel = loadImage("barrel.png");
}

void draw()
{
	SDL_FillRect(screen, &screen->clip_rect, SDL_MapRGB(screen->format, 0xFF, 0, 0));
	SDL_Rect dstrect = {375, 575, 50, 25};
	SDL_BlitSurface(bunker, NULL, screen, &dstrect);
	int mouse_x, mouse_y;
	SDL_GetMouseState(&mouse_x, &mouse_y);
	int x = mouse_x, y = 600 - mouse_y;
	double dx = x - 400, dy = y - 25;
	double angle = atan2(dy, dx);
	debug("mouse at d(%f, %f)", dx, dy);
	double angleDeg = angle * 180.0 / M_PI;
	debug("angle is %f", angle * 180.0 / M_PI );
	SDL_Rect srcrect = {200, 0, 100, 50};
	dstrect.x = 350;
	dstrect.y = 525;
	dstrect.w = 100;
	dstrect.h = 50;
	switch (angleDeg / 45) {
		case 0: srcrect.x = 400; break;
		case 1: srcrect.x = 300; break;
		case 2: srcrect.x = 200; break;
		case 3: srcrect.x = 100; break;
	}
	SDL_BlitSurface(barrel, &srcrect, screen, &dstrect);
	if (SDL_Flip(screen)) fatal(SDL_GetError());
}
