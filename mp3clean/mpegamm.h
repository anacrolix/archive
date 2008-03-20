#include <string>
#include <vector>

using namespace std;

class MpegAudioFrame
{
public:
	MpegAudioFrame(unsigned char header[4]);
	bool isValid();
private:
	off_t m_start;
	size_t m_length;
	unsigned char m_header[4];
};

class MpegID3v1Header
{
public:
	MpegID3v1Header(char header[128]);
	bool isValid();
private:
	char m_header[128];
};

class MpegAudioFile
{
public:
	MpegAudioFile(const string &filePath);
private:
	const string m_filePath;
	unsigned char m_dataHash[20];
	vector<MpegAudioFrame> m_frames;
};
