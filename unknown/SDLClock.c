/*
 * Cairo SDL clock. Shows how to use Cairo with SDL.
 * Made by Writser Cleveringa, based upon code from Eric Windisch.
 * Minor code clean up by Chris Nystrom (5/21/06)
 */

#include <stdlib.h>
#include <time.h>
#include <math.h>
#include <cairo/cairo.h>
#include "SDL.h"

#ifndef M_PI
#define M_PI 3.14159265358979323846
#endif

/* Pixel data for our clock */
unsigned char *clockData = NULL;

/* Surface constructed from pixel data */
SDL_Surface *clockSurface = NULL;

/* Clear all stuff on exit */
void onExit()
{
        free(clockData);
        SDL_FreeSurface(clockSurface);
        SDL_Quit();
}

/* Draws a clock on a normalized Cairo context */
void drawClock(cairo_t * cr)
{
        /* store the current time */
        time_t rawtime;
        time(&rawtime);
        struct tm *timeinfo;

        /* In newer versions of Visual Studio localtime(..) is deprecated. */
        /* Use localtime_s instead. See MSDN. */
        timeinfo = localtime(&rawtime);

        /* compute the angles for the indicators of our clock */
        double minutes = timeinfo->tm_min * M_PI / 30;
        double hours = timeinfo->tm_hour * M_PI / 6;
        double seconds = timeinfo->tm_sec * M_PI / 30;

        /* draw the entire context white. */
        cairo_set_source_rgba(cr, 1, 1, 1, 1);
        cairo_paint(cr);

        /* who doesn't want all those nice line settings :) */
        cairo_set_line_cap(cr, CAIRO_LINE_CAP_ROUND);
        cairo_set_line_width(cr, 0.05);

        /* translate to the center of the rendering context and draw a black */
        /* clock outline */
        cairo_set_source_rgba(cr, 0, 0, 0, 1);
        cairo_translate(cr, 0.5, 0.5);
        cairo_arc(cr, 0, 0, 0.4, 0, M_PI * 2);
        cairo_stroke(cr);

        /* draw a white dot on the current second. */
        cairo_set_source_rgba(cr, 1, 1, 1, 0.6);
        cairo_arc(cr, sin(seconds) * 0.4, -cos(seconds) * 0.4, 0.025, 0,
                  M_PI * 2);
        cairo_fill(cr);

        /* draw the minutes indicator */
        cairo_set_source_rgba(cr, 0.2, 0.2, 1, 0.6);
        cairo_move_to(cr, 0, 0);
        cairo_line_to(cr, sin(minutes) * 0.4, -cos(minutes) * 0.4);
        cairo_stroke(cr);

        /* draw the hours indicator      */
        cairo_move_to(cr, 0, 0);
        cairo_line_to(cr, sin(hours) * 0.2, -cos(hours) * 0.2);
        cairo_stroke(cr);
}

/* Shows how to draw with Cairo on SDL surfaces */
void drawScreen(SDL_Surface * screen)
{
        /* The drawing will exactly fit in the screen. */
        int width = screen->w;
        int height = screen->h;

        /* The number of bytes used for every scanline. */
        int stride = width * 4;

        /* Free old pixel data and allocate new space */
        free(clockData);
        clockData = (unsigned char *) calloc(stride * height, 1);

        /* Create a cairo surface for our allocated image. */
        /* We use the CAIRO_FORMAT_ARGB32 to support transparancy. */
        cairo_surface_t *cairo_surface =
            cairo_image_surface_create_for_data(clockData,
                                                CAIRO_FORMAT_ARGB32, width,
                                                height, stride);

        /* Create a cairo drawing context, normalize it and draw a clock. */
        /* Delete the context afterwards. */
        cairo_t *cr = cairo_create(cairo_surface);
        cairo_scale(cr, width, height);
        drawClock(cr);
        cairo_destroy(cr);

        /* We stored our image in ARGB32 format. We have to create a mask */
        /* for this format to tell SDL about our data layout. */
        Uint32 rmask = 0x00ff0000;
        Uint32 gmask = 0x0000ff00;
        Uint32 bmask = 0x000000ff;
        Uint32 amask = 0xff000000;

        /* Free old surface and create a new one from our pixel data. */
        SDL_FreeSurface(clockSurface);
        clockSurface =
            SDL_CreateRGBSurfaceFrom((void *) clockData, width, height, 32,
                                     stride, rmask, gmask, bmask, amask);

        /* Blit the clock to the screen and refresh */
        SDL_BlitSurface(clockSurface, NULL, screen, NULL);
        SDL_UpdateRect(screen, 0, 0, 0, 0);
}

SDL_Surface *initScreen(int width, int height, int bpp)
{
        /* Initialize SDL */
        if (SDL_Init(SDL_INIT_VIDEO | SDL_INIT_TIMER) < 0) {
                fprintf(stderr, "Unable to init SDL: %s\n",
                        SDL_GetError());
                exit(1);
        }
        atexit(onExit);

        /* Open a screen with the specified properties */
        SDL_Surface *screen = SDL_SetVideoMode(width, height, bpp,
                                               SDL_SWSURFACE |
                                               SDL_RESIZABLE);
        if (screen == NULL) {
                fprintf(stderr, "Unable to set %ix%i video: %s\n", width,
                        height, SDL_GetError());
                exit(1);
        }

        SDL_WM_SetCaption("Cairo clock - Press Q to quit", "ICON");
        return screen;
}

/* This function pushes a custom event onto the SDL event queue.
 * Whenever the main loop receives it, the window will be redrawn.
 * We can't redraw the window here, since this function could be called
 * from another thread.
 */
Uint32 callback_draw(Uint32 interval, void *param)
{
        SDL_Event event;
        event.type = SDL_USEREVENT;
        SDL_PushEvent(&event);

        /* We want the callback function to be called again in 100 ms. */
        return 100;
}

int main(int argc, char **argv)
{
        SDL_Surface *screen;
        SDL_Event event;

        /* Initialize SDL, open a screen */
        screen = initScreen(640, 480, 32);

        /* Create a timer which will redraw the screen every 100 ms. */
        SDL_AddTimer(100, callback_draw, NULL);

        while (1) {
                while (SDL_WaitEvent(&event)) {
                        switch (event.type) {
                        case SDL_KEYDOWN:
                                if (event.key.keysym.sym == SDLK_q) {
                                        exit(0);
                                }
                                break;

                        case SDL_QUIT:
                                exit(0);
                                break;

                        case SDL_VIDEORESIZE:
                                /* Resize the screen and redraw */
                                screen =
                                    SDL_SetVideoMode(event.resize.w,
                                                     event.resize.h, 32,
                                                     SDL_SWSURFACE |
                                                     SDL_RESIZABLE);
                                drawScreen(screen);
                                break;

                        case SDL_USEREVENT:
                                /* An event from callback_draw is received. */
                                /* Redraw the screen! */
                                drawScreen(screen);
                                break;

                        default:
                                break;
                        }
                }
        }
}
