#include <SDL/SDL.h>
#include "model.h"
#include "error.h"

SDL_Surface *screen = NULL;
//int fullscreen = 0;

void initView()
{
	screen = SDL_SetVideoMode(800, 600, 32, SDL_SWSURFACE);
	if (!screen) fatal(SDL_GetError());
	SDL_WM_SetCaption("Parashoot", NULL);
}

void draw()
{
	SDL_FillRect(screen, &screen->clip_rect, SDL_MapRGB(screen->format, 0, 0, 0));
	if (SDL_Flip(screen)) fatal(SDL_GetError());
}
