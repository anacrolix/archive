/*
 * What:    Experience Calculator for PvP-Enforced Kills
 * Version: 0.3
 * Author:  Matt aka Stupidape aka Eruanno
 * Date:    April 8, 2006, updated 1/10/06
 */

#ifdef __WINDOWS__
#include <windows.h>
#endif
#include <ctype.h>
#include <assert.h>
#include <curses.h>
#include <math.h>
#include <stdlib.h>

#define APP_VERSION 0.3
#define VICTIM_TITLE "Victim"
#define KILLER_TITLE "Killer"
#ifndef __WINDOWS__
#define TRUE 1
#define FALSE 0
#endif

#ifndef __WINDOWS__
typedef unsigned int UINT;
typedef int BOOL;
#endif

UINT killerExp, victimExp, expGained, killerLvl, victimLvl, numDeath, expLost;

UINT getExpByLevel(UINT lvl) {
  return (50.0/3.0) * pow(lvl, 3) - 100 * pow(lvl, 2) + 850.0/3.0 * lvl - 200;
}

UINT getLevelByExp (UINT exp) {
  UINT lvl = 1;
  while (getExpByLevel(lvl) < exp) lvl++;
  return lvl-1;
}

void printDetails(void) {
  printf("\nDeath #%3u.\n", numDeath);
  printf("%6s: level %3u, exp %9u (-%8u)\n", VICTIM_TITLE, victimLvl, victimExp, expLost);
  printf("%6s: level %3u, exp %9u ( %8u)\n", KILLER_TITLE, killerLvl, killerExp, expGained);
  return;
}

UINT expFromKill (void) {
  return (UINT)((1.0 - ((float)((killerLvl * 9) / 10) / (float)(victimLvl))) * victimExp / 20.0);
}

UINT getCharExp(char* title) {
	UINT level, exp;
	char c;
	printf("Enter %s level or experience? (l/e) ", title);
	do {
		c = getch();
	} while (c != 'l' && c != 'e');
	if (c == 'l') {
		printf("Enter %s level: ", title);
		scanf("%u", &level);
		exp = getExpByLevel(level);
	} else {
		printf("Enter %s experience: ", title);
		scanf("%u", &exp);
	}
	assert(exp >= 1500);
	return exp;
}

int main(void) {
  UINT maxDeaths;
  char c;
  BOOL isPrem;

  printf("\nWelcome to the PvP-Enforced Experience Calculator\n");
  printf("Version %.2f by Stupidape aka Eruanno\n", APP_VERSION);

	victimExp = getCharExp(VICTIM_TITLE);
	killerExp = getCharExp(KILLER_TITLE);

  printf("Maximum deaths : ");
  scanf("%u", &maxDeaths);
  assert(maxDeaths >= 1);
  printf("Victim premium? (y/n) ");
  c = getch();
  putchar('\n');
  c = tolower(c);
  if (c == 'y' || c == 'p' || c == 's' || c == '1') isPrem = TRUE;
  else isPrem = FALSE;

  victimLvl = getLevelByExp(victimExp);
  killerLvl = getLevelByExp(killerExp);

  for (numDeath = 1; numDeath <= maxDeaths; numDeath++)
   {
    expGained = expFromKill();
    if (expGained <= 0) {
      printf("\n\nNo more experience can be gained from killing this character");
      break;
    }
    if (isPrem) expLost = victimExp * 0.07;
    else expLost = victimExp * 0.1;
    killerExp += expGained;
    victimExp -= expLost;

    victimLvl = getLevelByExp(victimExp);
    killerLvl = getLevelByExp(killerExp);

    printDetails();
  }
  fflush(stdin);
  printf("\n");
  system("pause");
  return 0;
}
