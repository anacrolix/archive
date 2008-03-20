#include "mpegamm.h"

MpegAudioFrame::MpegAudioFrame(unsigned char header[4])
{
	memcpy(m_header, header, 4);
}

bool MpegAudioFrame::isValid()
{
	return ((m_header[0] & 0xff) && ((m_header[1] >> 5) & 0x7));
}

MpegID3v1Header::MpegID3v1Header(char header[128])
{
	memcpy(m_header, header, 128);
}

bool MpegID3v1Header::isValid()
{
	if (strncmp(&m_header[0], "TAG", 3) == 0) {
		return true;
	} else {
		return false;
	}
}

MpegAudioFile::MpegAudioFile(const string &filePath):
	m_filePath(filePath)
{

}
