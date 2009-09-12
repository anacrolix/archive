#include "reuters.h"
#include <climits>

using namespace std;

class Horspool
{
public:
    Horspool(string const &pattern)
    :   m_(pattern.size()),
        p_(pattern.c_str())
    {
        for (size_t j = 0; j < (1 << CHAR_BIT); ++j)
        {
            d_[j] = m_;
        }
        for (size_t j = 0; j < m_ - 1; ++j)
        {
            d_[static_cast<char unsigned>(pattern.at(j))] = m_ - j - 1;
        }
    }

    void operator()(
            char const *const buffer,
            size_t const length, size_t const already, Hits::value_type &hits)
    {
        char const *const end(buffer + length - m_ - 1);
        register char const *current(buffer);
        while (current < end)
        {
            register int j = m_ - 1;
            while (true)
            {
                if (j < 0)
                {
                    ++hits;
                }
                else if (current[j] == p_[j])
                {
                    --j;
                    continue;
                }
                break;
            }
            current += d_[static_cast<char unsigned>(current[m_ - 1])];
        }
    }

protected:
    size_t m_;
    size_t d_[1 << CHAR_BIT];
    char const *p_;
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
