#include <math.h>
#include <stdio.h>
#include <assert.h>
#include "tibia-xp.h"

tibia_exp_t tibia_exp_for_level(tibia_level_t level)
{
	tibia_exp_t exp = ((50 * level * level * level - 300 * level * level + 850 * level) / 3 - 200);
	assert(!(exp % 100));
	//fprintf(stderr, "level %lld requires %lld exp\n", level, exp);
	return exp;
}

tibia_level_t tibia_level_from_exp(tibia_exp_t exp)
{
	tibia_level_t level;
	for (level = 0; exp >= tibia_exp_for_level(level + 1); level++);
	return level;
}

tibia_exp_t tibia_pvp_kill_exp_gain(tibia_level_t killer_level, tibia_level_t victim_level)
{
	tibia_exp_t victimExp = tibia_exp_for_level(victim_level);
	tibia_exp_t expGain = (victimExp * (victim_level - (9 * killer_level) / 10)) / (20 * victim_level);
	if (expGain < 0)
		return 0;
	else
		return expGain;
}

tibia_exp_t tibia_exp_loss_from_death(tibia_exp_t exp, int premium)
{
	return (double)exp * (premium ? 0.07 : 0.1);
}
