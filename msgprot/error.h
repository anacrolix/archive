#ifndef error_h
#define error_h

#define err_fatal fatal_error
#define err_debug debug

void fatal_error(const char *, ...);
void debug_error(const char *, ...);
void fatal(const char *, ...);
void debug(const char *, ...);

#endif
