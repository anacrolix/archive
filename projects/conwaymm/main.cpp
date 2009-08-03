#include "eruutil/debug.h"
#include <boost/thread.hpp>
#include <SDL/SDL.h>
#include <time.h>

unsigned const
    GRID_WIDTH = 400,
    GRID_HEIGHT = 300,
    SCREEN_BPP = 32,
    CELL_WIDTH = 2,
    CELL_HEIGHT = 2,
    UPDATES_PER_FRAME = 1,
    FRAME_RATE = 25,
    NR_PROCESSORS = boost::thread::hardware_concurrency();

class Cell
{
public:
    Cell() : alive_(false) {}

    Cell(Uint8 r, Uint8 g, Uint8 b)
	:   alive_(true), r_(r), g_(g), b_(b) {}

    bool is_alive() const { return alive_; }

    Uint8 r() const { return r_; }
    Uint8 g() const { return g_; }
    Uint8 b() const { return b_; }

private:
    bool alive_;
    Uint8 r_, g_, b_;
};

class World
{
public:
    World(int width, int height)
	:	width_(width),
	height_(height),
	cells_(new Cell [width * height])
    {
    }

    ~World() { delete [] cells_; }

    void randomize() {
	for (int y = 0; y < height_; y++)
	{
	    for (int x = 0; x < width_; x++)
	    {
		if (rand() < RAND_MAX / 4)
		{
		    cells_[y * width_ + x] = Cell(
			(x > width_ / 2) ? UCHAR_MAX : 0,
			0,
			(x < width_ / 2) ? UCHAR_MAX : 0);
		}
	    }
	}
    }

    void draw(SDL_Surface *surface) {
	for (int y = 0; y < height_; y++) {
	    for (int x = 0; x < width_; x++) {
		Cell const &cell(cells_[y * width_ + x]);
		if (cell.is_alive()) {
		    SDL_Rect rect;
		    rect.x = x * ::CELL_WIDTH;
		    rect.y = y * CELL_HEIGHT;
		    rect.w = CELL_WIDTH;
		    rect.h = CELL_HEIGHT;
		    SDL_FillRect(
			surface, &rect,
			SDL_MapRGB(surface->format, cell.r(), cell.g(), cell.b()));
		}
	    }
	}
    }

#if 0
    void iterate(World const &prev)
    { //cell_t *oldWorld, cell_t *newWorld, int firstRow, int lastRow
	int width = GRID_WIDTH;
	int height = GRID_HEIGHT;
	long firstRow = (long)arg;
	int lastRow = firstRow + height / NR_PROCESSORS;
	for (int y = firstRow; y < lastRow; y++) {
	    for (int x = 0; x < width; x++) {
		int adj = 0, r = 0, g = 0, b = 0;
		for (int j = y - 1; j <= y + 1; j++) {
		    //if (j < 0 || j >= height) continue;
		    for (int i = x - 1; i <= x + 1; i++) {
			if (i == x && j == y) continue;
			int n = j % height; if (n < 0) n += height;
			int m = i % width; if (m < 0) m += width;
			//if (i < 0 || i >= width) continue;
			cell_t *cell = &oldWorld[n * width + m];
			if (cell->state) {
			    //printf("(%d, %d) has neighbour (%d, %d)\n",
			    //  x, y, m, n);
			    adj++;
			    r += cell->r;
			    g += cell->g;
			    b += cell->b;
			}
		    }
		}
		cell_t cell;
		cell.r = UCHAR_MAX;
		cell.g = UCHAR_MAX;
		cell.b = UCHAR_MAX;
		if (adj < 2 || adj > 3) {
		    cell.state = 0;
		    cell.g = 0;
		} else if (adj == 2)
		    cell = oldWorld[y * width + x];
		else if (adj == 3) {
		    cell.state = 1;
		    cell.r = r / 3;
		    cell.b = b / 3;
		    cell.g = 0xFF - cell.r - cell.b;
		}
		newWorld[y * width + x] = cell;
	    }
	}
	return NULL;
    }
#endif

private:
    Cell *cells_;
    int width_, height_;
};

class Screen
{
public:
    Screen(int width, int height)
	:   fullscreen_(false), width_(width), height_(height)
    {
	set_video_mode();
    }

    ~Screen() { SDL_FreeSurface(surface_); }

    bool fullscreen() { return fullscreen_; }

    void fullscreen(bool fullscreen) {
	fullscreen_ = fullscreen;
	set_video_mode();
    }

    SDL_Surface *surface() { return surface_; }

    void flip() {
	SDL_Flip(surface_); // check this is 0
    }

private:
    bool fullscreen_;
    int width_, height_;
    SDL_Surface *surface_;

    void set_video_mode() {
	surface_ = SDL_SetVideoMode(
	    width_, height_, 32,
	    SDL_HWSURFACE | SDL_DOUBLEBUF | (fullscreen_ ? SDL_FULLSCREEN : 0));
    }
};

#if 0
void draw()
{
#if 0
    cell_t *world = (cell_t *)arg;
    SDL_FillRect(screen, &screen->clip_rect,
	SDL_MapRGB(screen->format, 0, 0, 0));
    for (int y = 0; y < GRID_HEIGHT; y++) {
	for (int x = 0; x < GRID_WIDTH; x++) {
	    if (world[y * GRID_WIDTH + x].state) {
		SDL_Rect rect =
		{x * CELL_WIDTH, y * CELL_HEIGHT,
		GRID_WIDTH, GRID_HEIGHT};
		SDL_FillRect(screen, &rect, SDL_MapRGB(
		    screen->format, world[y * GRID_WIDTH + x].r, world[y * GRID_WIDTH + x].g, world[y * GRID_WIDTH + x].b));
	    }
	}
    }
    return NULL;
#else
    world->draw(screen->surface());
    screen->flip();
#endif
}
#endif

#if 0
void update()
{
    // swap world buffers
    world = oldWorld;
    oldWorld = newWorld;
    newWorld = world;

    SDL_Thread **threads = new SDL_Thread *[NR_PROCESSORS];
    // create update threads
    for (long t = 0; t < NR_PROCESSORS; t++)
    {
        threads[t] = SDL_CreateThread(
                updateWorld,
                reinterpret_cast<void *>(t * GRID_HEIGHT / NR_PROCESSORS));
    }
    // join update threads
    for (long t = 0; t < NR_PROCESSORS; t++)
    {
        SDL_WaitThread(threads[t], NULL);
    }
    world = newWorld;
    generation++;
        delete[] threads;
}
#endif

#if 0
void loop()
{
    int fpsStartFrame = generation;
    Uint32 fpsStartTicks = SDL_GetTicks();
    while (true)
	{
        draw();
        Uint32 fpsCurTicks = SDL_GetTicks();
        Uint32 waitDelay = 1000 / FRAME_RATE * (generation - fpsStartFrame + 1) - fpsCurTicks + fpsStartTicks;
        if (waitDelay > 1000 / FRAME_RATE) printf("%d\n", waitDelay);
        if (waitDelay > 1000 / FRAME_RATE) waitDelay = 1000 / FRAME_RATE;
        if (waitDelay > 0) SDL_Delay(waitDelay);
        if (fpsCurTicks - fpsStartTicks >= 1000)
                {
            printf("%d ticks have passed\n", fpsCurTicks - fpsStartTicks);
            printf("%d frames have passed\n", generation - fpsStartFrame);
            char caption[32];
            sprintf(caption, "%s - %.1f fps", WINDOW_CAPTION, ((float)(generation - fpsStartFrame)) / (((float)(fpsCurTicks - fpsStartTicks)) / 1000.f));
            fpsStartFrame = generation;
            fpsStartTicks = fpsCurTicks;
            SDL_WM_SetCaption(caption, NULL);
        }
        events();
        if (quit) break;
        for (int f = 0; f < UPDATES_PER_FRAME; f++)
            update();
    }
}
#endif

int main(int, char **)
{
    if (SDL_Init(SDL_INIT_VIDEO | SDL_INIT_TIMER) != 0) {
	exit(EXIT_FAILURE);
    }
    srand(time(NULL));

    Screen screen(GRID_WIDTH * CELL_WIDTH, GRID_HEIGHT * CELL_HEIGHT);
    SDL_WM_SetCaption("Conway SDL", NULL);
    World world_a(GRID_WIDTH, GRID_HEIGHT);
    World world_b(GRID_WIDTH, GRID_HEIGHT);

    bool quit = false;
    while (quit == false)
    {
	SDL_Delay(10);

	SDL_Event event;
	while (SDL_PollEvent(&event))
	{
	    switch (event.type)
	    {
	    case SDL_QUIT:
		    quit = true;
		break;
	    case SDL_KEYDOWN:
		switch (event.key.keysym.sym)
		{
		case SDLK_ESCAPE:
		    quit = true;
		    break;
		case SDLK_RETURN:
		    screen.fullscreen(screen.fullscreen());
		    break;
		};
		break;
	    };
	}
    }

    SDL_Quit();
    return EXIT_SUCCESS;
}
