#include <SDL/SDL.h>
#include "view.h"
#include "model.h"
#include "error.h"

int quit = 0;

void initSDL()
{
	if (SDL_Init(SDL_INIT_VIDEO | SDL_INIT_TIMER)) fatal(SDL_GetError());
	atexit(SDL_Quit);
}

void events()
{
	SDL_Event event;
	while (SDL_PollEvent(&event)) {
		if (event.type == SDL_QUIT || (event.type == SDL_KEYDOWN && event.key.keysym.sym == SDLK_ESCAPE)) {
			quit = 1;
		}
	}
}

void run()
{
	while (1) {
		events();
		if (quit) break;
		draw();
		SDL_Delay(50);
	}
}

void start()
{
	initSDL();
	initView();
	run();
}

