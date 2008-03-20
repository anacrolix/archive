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

class MpegHeaderId3v1
{
public:
	MpegHeaderId3v1(char header[128]);
	bool isValid();
	const char *data();
private:
	char m_header[128];
};

class MpegHeaderId3v2
{};

class MpegAudioFile
{
public:
	MpegAudioFile(const string &filePath);
	~MpegAudioFile();
	MpegHeaderId3v1 *getHeaderId3v1(bool closeFile = true);
private:
	bool openFile();
	bool closeFile();

	const string m_filePath;
	unsigned char *m_dataHash;
	vector<MpegAudioFrame> m_frames;
	MpegHeaderId3v1 *m_headerId3v1;
	MpegHeaderId3v2 *m_headerId3v2;
	FILE *m_fileStream;
};
