#include "reuters.hh"
#include <limits.h>

using namespace std;

class Horspool
{
public:
    Horspool(string pattern)
    :   m_(pattern.size()),
        d_(1 << CHAR_BIT, m_),
        p_(pattern)
    {
        for (size_t j = 0; j < m_ - 1; ++j)
        {
            d_.at(pattern.at(j)) = m_ - j - 1;
        }
    }

    void operator()(
            char const *const buffer,
            size_t length, size_t already, Hits::value_type &hits)
    {
        size_t pos = 0;
        while (pos <= length - m_)
        {
            size_t j = m_;
            while (j > 0 && buffer[pos + j - 1] == p_[j - 1]) --j;
            if (j == 0)
                //ASSERT_TRUE(hits.insert(pos + already).second);
				hits.insert(pos + already);
            pos += d_[static_cast<char unsigned>(buffer[pos + m_ - 1])];
        }
    }

protected:
    size_t m_;
    vector<size_t> d_;
    string p_;
};

class MultiHorspool : public SearchInstance
{
public:
    MultiHorspool(Keywords const &keywords)
    {
        for (Keywords::const_iterator kw_it(keywords.begin()); kw_it != keywords.end(); ++kw_it)
        {
            horspools_.push_back(Horspool(*kw_it));
        }
    }

    virtual void operator()(char const *buffer, size_t length, size_t already, Hits &hits)
    {
        ASSERT_EQ(hits.size(), horspools_.size());
        for (size_t i = 0; i < horspools_.size(); ++i)
        {
            horspools_[i](buffer, length, already, hits[i]);
        }
    }

protected:
    vector<Horspool> horspools_;
};

TEST_F(Reuters21578, Horspool)
{
    MultiHorspool a(keywords());
    search_wrapper(a);
}
