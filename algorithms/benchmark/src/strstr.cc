#include "reuters.h"

class StrStr : public SearchInstance
{
public:
    StrStr(Keywords const &keywords) : keywords_(keywords) {}

    virtual void operator()(char const *buffer, size_t length, size_t already, Hits &hits)
    {
        for (size_t kw_i = 0; kw_i < keywords_.size(); ++kw_i)
        {
            for (   char const *where = buffer;
                    (where = strstr(where, keywords_[kw_i].c_str())) != NULL;
                    ++where)
                hits[kw_i] += 1;
        }
    }

protected:
    Keywords const &keywords_;
};

TEST_F(Reuters21578, strstr)
{
    StrStr search_instance(keywords());
    search_wrapper(search_instance);
}
