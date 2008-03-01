#include <stdlib.h>
#include <time.h>
#include <SDL/SDL.h>

const int
	SCREEN_WIDTH = 1200,
	SCREEN_HEIGHT = 800,
	SCREEN_BPP = 32,
	GRID_WIDTH = 10,
	GRID_HEIGHT = 10;

const char
	WINDOW_CAPTION[] = "SDL Life";

SDL_Surface
	*screen = NULL;

int
	fullscreen = 0,
	quit = 0,
	points = 0,
	generation = 0;

char *world = NULL;
char *newWorld, *oldWorld;

void cleanup()
{
	if (screen) SDL_FreeSurface(screen);
	if (world) free(world);
	SDL_Quit();
}

void init()
{
	if (SDL_Init(SDL_INIT_VIDEO | SDL_INIT_TIMER))
		exit(EXIT_FAILURE);
	atexit(cleanup);
	screen = SDL_SetVideoMode(
		SCREEN_WIDTH, SCREEN_HEIGHT, SCREEN_BPP, SDL_SWSURFACE);
	if (!screen) exit(EXIT_FAILURE);
	SDL_WM_SetCaption(WINDOW_CAPTION, NULL);
	newWorld = calloc(SCREEN_WIDTH / GRID_WIDTH * SCREEN_HEIGHT / GRID_HEIGHT, 1);
	int width = SCREEN_WIDTH / GRID_WIDTH;
	int height = SCREEN_HEIGHT / GRID_HEIGHT;
	newWorld = calloc(width * height, 1);
	oldWorld = calloc(width * height, 1);
	if (!newWorld || !oldWorld) exit(EXIT_FAILURE);
	world = newWorld;
	srand(time(NULL));
	for (int y = 0; y < height; y++) {
		for (int x = 0; x < width; x++) {
			if (rand() < RAND_MAX / 4)
				world[y * width + x] = 1;
		}
	}
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

void draw()
{
	SDL_FillRect(screen, &screen->clip_rect,
		SDL_MapRGB(screen->format, 0xFF, 0xFF, 0xFF));
	int width = SCREEN_WIDTH / GRID_WIDTH;
	int height = SCREEN_HEIGHT / GRID_HEIGHT;
	for (int y = 0; y < height; y++) {
		for (int x = 0; x < width; x++) {
			if (world[y * width + x]) {
				SDL_Rect rect =
					{x * GRID_WIDTH, y * GRID_HEIGHT,
					GRID_WIDTH, GRID_HEIGHT};
				SDL_FillRect(screen, &rect, SDL_MapRGB(screen->format, 0xFF, 0, 0));
			}
		}
	}
	if (SDL_Flip(screen)) exit(EXIT_FAILURE);
}

void update()
{
	world = oldWorld;
	oldWorld = newWorld;
	newWorld = world;
	int width = SCREEN_WIDTH / GRID_WIDTH;
	int height = SCREEN_HEIGHT / GRID_HEIGHT;
	for (int y = -1; y <= height; y++) {
		for (int x = -1; x <= width; x++) {
			int adj = 0;
			for (int j = y - 1; j <= y + 1; j++) {
				if (j < 0 || j >= height) continue;
				for (int i = x - 1; i <= x + 1; i++) {
					if (i == x && j == y) continue;
					if (i < 0 || i >= width) continue;
					if (oldWorld[j * width + i]) adj++;
				}
			}
			if (x != -1 && x != width && y != -1 && y != height) {
				if (adj < 2 || adj > 3)
					newWorld[y * width + x] = 0;
				else if (adj == 2)
					newWorld[y * width + x] = oldWorld[y * width + x];
				else if (adj == 3)
					newWorld[y * width + x] = 1;
			} else {
				if (adj == 3) {
					points++;
					//printf("generation %d scored a point! (sum == %d)\n", generation, points);
				}
			}
		}
	}
	world = newWorld;
	generation++;
}

void loop()
{
	while (1) {
		draw();
		SDL_Delay(50);
		events();
		if (quit) break;
		update();
	}
}

int main(int argc, char *argv[])
{
	init();
	loop();
	return EXIT_SUCCESS;
}
