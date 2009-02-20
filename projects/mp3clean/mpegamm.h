#include <string>
#include <vector>

using namespace std;

struct MpegFrameHeader
{
	off_t offset;
	char data[4];
	bool followFrame(vector<MpegFrameHeader> &vfh, FILE *fs);
};

struct MpegId3v1Header
{
	char data[128];
};

struct MpegId3v2Header
{
	char data[10];
};

struct MpegAudioFile
{
	MpegAudioFile(const string &name_);

	string name;
	MpegId3v1Header *id3v1Header;
	MpegId3v2Header *id3v2Header;
	vector<MpegFrameHeader> frames;
};
