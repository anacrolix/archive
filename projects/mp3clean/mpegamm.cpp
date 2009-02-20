#include "mpegamm.h"
#include "../eruutil/erudebug.h"
#include <cerrno>
#include <cassert>

//#define GETBITS(a, b, c) ((a >> )

MpegAudioFile::MpegAudioFile(const string &name_):
	name(name_),
	id3v1Header(NULL),
	id3v2Header(NULL)
{
	FILE *fs = fopen(name.data(), "rb");
	if (fs) {
		// get id3v1 header
		if (fseek(fs, -128, SEEK_END)) {
			warn(errno, "fseek()");
		} else {
			MpegId3v1Header *v1hdr = new MpegId3v1Header();
			if (fread(v1hdr->data, 1, sizeof(v1hdr->data), fs) != sizeof(v1hdr->data)) {
				warn(errno, "fread()");
			} else {
				if (!strncmp(v1hdr->data, "TAG", 3)) {
					id3v1Header = v1hdr;
				}
			}
			if (!id3v1Header) delete v1hdr;
		}
		rewind(fs);
		// get id3v2 header
		MpegId3v2Header *v2hdr = new MpegId3v2Header();
		if (fread(v2hdr->data, 1, sizeof(v2hdr->data), fs) != sizeof(v2hdr->data)) {
			warn(errno, "fread()");
		} else {
			if (!strncasecmp(v2hdr->data, "ID3", 3)) {
				id3v2Header = v2hdr;
			}
		}
		if (!id3v2Header) delete v2hdr;
		// get frames
		rewind(fs);
		MpegFrameHeader fhdr;
		for (off_t foff = 0;; foff++) {
			if (fread(fhdr.data, 1, 4, fs) != 4) {
				if (ferror(fs)) warn(errno, "fread()");
				break;
			} else {
				long &bits = (long &)*(fhdr.data);
				if ((bits & 0xfe000000) == 0xfe000000) {
					fhdr.offset = ftell(fs);
					frames.push_back(fhdr);
				}
			}
		}
		// close file
		fclose(fs);
	}
}

bool MpegFrameHeader::followFrame(vector<MpegFrameHeader> &vfh, FILE *fs)
{
	MpegFrameHeader fhdr;
	fhdr.offset = ftell(fs);
	if (fread(fhdr.data, 1, 4, fs) != 4) {
		if (feof(fs)) {
			return true;
		} else if (ferror(fs)) {
			warn(errno, "fread()");
			return false;
		} else {
			assert(false);
		}
	} else {
		long &bits = (long &)*(fhdr.data);
		if ((bits & 0xfe000000) == 0xfe000000) {
			// calculate offset to next frame header
			debug("%u", uint(fhdr.offset));
			if (((bits >> 19) & 0x3) == 0x2) {
				debug("reserved version");
				goto a;
			}
a:
			debug("\n");
			return false;
		} else {
			return false;
		}
	}
	assert(false);
	return false;
}
