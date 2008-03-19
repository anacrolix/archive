#include <string.h>
#include <strings.h>
#include <assert.h>

char *strrcasestr(const char *hay, const char *ndl)
{
	char *ret = NULL;
	size_t haylen = strlen(hay);
	size_t ndllen = strlen(ndl);
	if (ndllen > haylen) goto done;
	assert(haylen >= ndllen);
	size_t i;
	for (i = haylen - ndllen; i >= 0; i--) {
		if (!strncasecmp(&hay[i], ndl, ndllen)) {
			break;
		}
	}
	if (i == -1) goto done;
	ret = (char *)&hay[i];
done:
	return ret;
}
