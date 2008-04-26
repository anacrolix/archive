#include "allocex.h"
#include "pallocf.h"
#include "procmaps.h"
#include "debug.h"
#include <stdio.h>
#include <string.h>
#include <errno.h>
#include <assert.h>
#include <error.h>
#include <stdlib.h>
#include <stdint.h>

void print_proc_maps(procmap_t *maps, int count)
{
	for (int i = 0; i < count; i++) {
		procmap_t *m = &maps[i];
		int printed = printf(
			"%08lx-%08lx %4s %08lx %02hhx:%02hhx %-lu",
			(intptr_t)m->start, (intptr_t)m->end, m->perms, m->offset,
			m->major, m->minor, m->inode);
		for (int j = 0; j < 73 - printed; j++) putchar(' ');
		puts(m->path);
	}
}

/// converts a line from a /proc/%d/maps file to a procmap_t
static bool parse_proc_maps_line(const char *line, procmap_t *map)
{
	static_assert(sizeof(off_t) == sizeof(long int));
	static_assert(sizeof(size_t) == sizeof(unsigned long int));
	int items = sscanf(line, "%p-%p %4c %lx %hhx:%hhx %lu",
		&map->start, &map->end, map->perms, &map->offset, &map->major,
		&map->minor, &map->inode);
	if (items != 7) return false;
	verify(strncpy(map->path, &line[73], sizeof(map->path)) == map->path);
	return true;
}

/// reads /proc/%d/maps file information into an array of procmap_t
bool get_proc_maps(pid_t pid, procmap_t **maps, int *count)
{
	// get maps path
	char *path = mprintf("/proc/%d/maps", pid);
	// open maps file
	FILE *file = fopen(path, "rb");
	int ev = errno;
	free(path);
	if (!file) {
		warn(ev, "fopen()");
		return false;
	}
	// fill maps array
	*maps = xcalloc(0x100, sizeof(procmap_t));
	*count = 0;
	while (true) {
		char line[73 + 0x100 + 2];
		if (!fgets(line, sizeof(line), file)) break;
		assert(line[strlen(line) - 1] == '\n');
		line[strlen(line) - 1] = '\0';
		if (!parse_proc_maps_line(line, &(*maps)[*count])) {
			warn(0, "parse_proc_maps_line()");
			continue;
		}
		(*count)++;
	}
	// report and cleanup
	trace("%d", *count);
	fclose(file);
	*maps = realloc(*maps, *count * sizeof(**maps));
	assert(*maps);
	return true;
}
