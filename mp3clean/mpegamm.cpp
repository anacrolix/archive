#include "mpegamm.h"
#include "../eruutil/erudebug.h"
#include <errno.h>

MpegAudioFrame::MpegAudioFrame(unsigned char header[4])
{
	memcpy(m_header, header, 4);
}

bool MpegAudioFrame::isValid()
{
	return ((m_header[0] & 0xff) && ((m_header[1] >> 5) & 0x7));
}

MpegHeaderId3v1::MpegHeaderId3v1(char header[128])
{
	memcpy(m_header, header, 128);
}

bool MpegHeaderId3v1::isValid()
{
	if (strncmp(&m_header[0], "TAG", 3) == 0) {
		return true;
	} else {
		return false;
	}
}

const char *MpegHeaderId3v1::data()
{
	return m_header;
}

MpegAudioFile::MpegAudioFile(const string &filePath):
	m_filePath(filePath),
	m_dataHash(NULL),
	m_headerId3v1(NULL),
	m_headerId3v2(NULL),
	m_fileStream(NULL)
{
	if (openFile()) closeFile();
}

MpegAudioFile::~MpegAudioFile()
{
	delete[] m_dataHash;
	delete m_headerId3v1;
	delete m_headerId3v2;
}

MpegHeaderId3v1 *MpegAudioFile::getHeaderId3v1(bool closeFile)
{
	if (!m_headerId3v1) {
		if (openFile()) {
			if (fseek(m_fileStream, -128, SEEK_END)) {
				warn(errno, "fseek()");
			} else {
				char buf[128];
				if (fread(buf, 1, 128, m_fileStream) == 128) {
					m_headerId3v1 = new MpegHeaderId3v1(buf);
				}
			}
		}
	}
	if (closeFile) this->closeFile();
	return m_headerId3v1;
}

bool MpegAudioFile::openFile()
{
	if (!closeFile()) return false;
	m_fileStream = fopen(m_filePath.data(), "rb");
	if (m_fileStream == NULL) {
		warn(errno, "fopen()");
		return false;
	}
	return true;
}

bool MpegAudioFile::closeFile()
{
	if (m_fileStream) {
		if (fclose(m_fileStream)) {
			warn(errno, "fclose()");
			return false;
		}
		m_fileStream = NULL;
	}
	return true;
}
