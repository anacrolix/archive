#include "reuters.hh"

class StrStr : public SearchInstance
{
public:
    StrStr(Keywords const &keywords) : keywords_(keywords) {}

    virtual void operator()(char const *const buffer, size_t length, size_t already, Hits &hits)
    {
        for (Keywords::const_iterator kw_it(keywords_.begin());
            kw_it != keywords_.end(); ++kw_it)
        {
            for (char const *where = buffer; (where = strstr(where, kw_it->c_str())) != NULL; ++where)
            {
                size_t offset = where - buffer + already;
                size_t keyword_index = std::distance(keywords_.begin(), kw_it);
                //std::cout << kw_it->c_str() << ": " << offset << std::endl;
                ASSERT_TRUE(hits.at(keyword_index).insert(offset).second);
            }
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
