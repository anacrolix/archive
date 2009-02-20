#include "miniplay.h"

#define MAIN_GROUPNAME "general"
#define VOLUME_KEY "volume"
#define MUSICDIR_KEY "music_dir"

static GKeyFile *keyfile_ = NULL;
static gchar const *settings_path_ = NULL;
static gchar const *confdir_path_ = NULL;

static gboolean get_config_dir_lock()
{
	g_assert(confdir_path_);

	gchar *lockfile_path = g_build_filename(
			confdir_path_, "lock", NULL);
	int fd = g_open(lockfile_path, O_RDONLY | O_CREAT, 0666);
	g_free(lockfile_path);

	if (fd == -1) {
		g_printerr("could not open lock file: %s\n", strerror(errno));
		return FALSE;
	}
	if (flock(fd, LOCK_EX | LOCK_NB)) {
		g_printerr(
				"could not obtain exclusive lock: %s\n",
				strerror(errno));
		close(fd);
		return FALSE;
	}
	return TRUE;
}

gboolean mp_conf_init(gchar const *conf_path)
{
	g_assert(conf_path);

	confdir_path_ = g_strdup(conf_path);
	if (!get_config_dir_lock()) {
		return FALSE;
	}

	settings_path_ = g_build_filename(conf_path, "settings", NULL);

	keyfile_ = g_key_file_new();
	g_assert(keyfile_);

	g_debug("loading settings file: %s", settings_path_);
	GError *error = NULL;
	if (!g_key_file_load_from_file(
				keyfile_, settings_path_, 0, &error)) {
		g_debug("failed to load settings file: %s", error->message);
		g_error_free(error);
	}
	else {
		g_assert(!error);
	}

	return TRUE;
}

void mp_conf_save()
{
	/* create user miniplay conf directory */
	gchar *dir = g_path_get_dirname(settings_path_);
	int d = g_mkdir(dir, 0750);
	if (d == -1) g_debug("failed to create miniplay conf dir");
	g_free(dir);

	gsize length;
	gchar *data = g_key_file_to_data(keyfile_, &length, NULL);
	GError *error = NULL;
	g_file_set_contents(settings_path_, data, length, &error);
	if (error) {
		g_printerr("saving settings: %s", error->message);
		g_error_free(error);
	}
}

gboolean mp_conf_has_music_dir()
{
	return g_key_file_has_key(
			keyfile_, MAIN_GROUPNAME, MUSICDIR_KEY, NULL);
}

gchar const *mp_conf_get_music_dir()
{
	return g_key_file_get_string(
			keyfile_, MAIN_GROUPNAME, MUSICDIR_KEY, NULL)
		? : g_get_user_special_dir(G_USER_DIRECTORY_MUSIC);
}

void mp_conf_set_music_dir(gchar const *music_dir)
{
	g_key_file_set_string(
			keyfile_, MAIN_GROUPNAME, MUSICDIR_KEY, music_dir);
}

gdouble mp_conf_get_volume()
{
	GError *error = NULL;
	gdouble rv = g_key_file_get_double(
			keyfile_, MAIN_GROUPNAME, VOLUME_KEY, &error);
	if (rv == 0.0 && error) {
		rv = 0.4;
		g_error_free(error);
	}
	return rv;
}

void mp_conf_set_volume(gdouble volume)
{
	g_key_file_set_double(
			keyfile_, MAIN_GROUPNAME, VOLUME_KEY, volume);
}
