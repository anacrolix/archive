typedef long long int tibia_exp_t, tibia_level_t;
//typedef long long int tibia_level_t;

tibia_exp_t tibia_pvp_kill_exp_gain(
	tibia_level_t killer_level,
	tibia_level_t victim_level);

tibia_level_t tibia_level_from_exp(tibia_exp_t exp);

tibia_exp_t tibia_exp_for_level(tibia_level_t level);

tibia_exp_t tibia_exp_loss_from_death(tibia_exp_t exp, int premium);
