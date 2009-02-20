#include "mpegamm.h"

#include <string>

using namespace std;

int main()
{
	MpegAudioFile mp3("a.mp3");
	if (mp3.id3v1Header) puts("has id3v1 header");
	if (mp3.id3v2Header) puts("has id3v2 header");
	vector<MpegFrameHeader>::iterator i;
	for (i = mp3.frames.begin(); i != mp3.frames.end(); ++i) {
		printf("%u\n", uint(i->offset));
	}
	return 0;
}
