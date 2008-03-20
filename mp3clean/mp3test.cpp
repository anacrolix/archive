#include "mpegamm.h"

#include <string>

using namespace std;

int main()
{
	string fpath("a.mp3");
	MpegAudioFile mp3(fpath);
	MpegHeaderId3v1 *hdr1 = mp3.getHeaderId3v1();
	if (hdr1 && hdr1->isValid()) printf("%3s\n", hdr1->data());
	return 0;
}
