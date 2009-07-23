#pragma once

#include <gtest/gtest.h>

typedef std::vector<std::set<size_t> > Hits;
typedef std::vector<std::string> Keywords;

class SearchInstance
{
public:
    virtual void operator()(char const *buffer, size_t length, size_t already, Hits &hits) = 0;
};

class Reuters21578 : public testing::Test
{
protected:
    static char const *const KEYWORD_FILES[];

    virtual void SetUp();
    virtual void TearDown();

    void search_wrapper(SearchInstance &search_function);

    inline Keywords const &keywords() const { return keywords_; }

    Hits hits_;

private:
    Keywords keywords_;
    //std::vector<std::vector<char> > haystacks_;
};
