#pragma once

#include <gtest/gtest.h>

typedef std::vector<size_t> Hits;
typedef std::vector<std::string> Keywords;

class SearchInstance
{
public:
    virtual void operator()(char const *buffer, size_t length, size_t already, Hits &hits) = 0;
};

class Reuters21578 : public testing::Test
{
protected:
	//Reuters21578();
	//virtual ~Reuters21578();
    virtual void SetUp();
    virtual void TearDown();

    void search_wrapper(SearchInstance &search_function);
	size_t actual_hit_count() const;

    inline Keywords const &keywords() const { return keywords_; }

    Hits hits_;

private:
    static char const *const KEYWORD_FILES[];

	static size_t expected_hit_count();

    Keywords keywords_;
	double search_time_;
};
