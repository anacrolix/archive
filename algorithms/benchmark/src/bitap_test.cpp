#include "reuters.h"
#include <boost/shared_array.hpp>

using boost::shared_array;
using namespace std;

class Bitap
{
public:
	typedef long BitArray;

    Bitap(char const *pattern)
    :   p5nlen_(strlen(pattern))
    {
		if (p5nlen_ >= sizeof(BitArray) * CHAR_BIT) throw exception();
		if (p5nlen_ <= 0 || pattern[0] == '\0') throw exception();

		/* Initialize the pattern bitmasks */
		for (int i = 0; i <= UCHAR_MAX; ++i)
			p5nmask_[i] = ~0;
		for (int i = 0; i < p5nlen_; ++i)
			p5nmask_[pattern[i]] &= ~(1UL << i);
    }

    inline char const *operator()(char const *text, size_t length)
    {
		register BitArray r(~1);

		char const *const end(text + length);
		for ( ; text != end; ++text)
		{
			/* Update the bit array */
			r |= p5nmask_[*text];
			r <<= 1;

			if (0 == (r & (1UL << p5nlen_)))
				return text;
		}

		return NULL;
    }

protected:
    size_t p5nlen_;
	BitArray p5nmask_[UCHAR_MAX + 1];
    shared_array<char> pattern_;
};

class MultiBitap : public SearchInstance
{
public:
    MultiBitap(Keywords const &keywords)
    {
        for (Keywords::const_iterator kw(keywords.begin()); kw != keywords.end(); ++kw)
        {
            bitaps_.push_back(Bitap(kw->c_str()));
        }
    }

    virtual void operator()(char const *buffer, size_t length, size_t already, Hits &hits)
    {
        for (size_t i = 0; i < bitaps_.size(); ++i)
        {
            for (   char const *_where = buffer;
                    (_where = bitaps_[i](_where, length - (_where - buffer))) != NULL;
                    ++_where)
                hits[i] += 1;
        }
    }

protected:
    vector<Bitap> bitaps_;
};

TEST_F(Reuters21578, Bitap)
{
    MultiBitap a(keywords());
    search_wrapper(a);
}
