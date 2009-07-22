#include <gtest/gtest.h>
#include <boost/filesystem.hpp>
#include <fstream>
#include <sstream>
#include <iostream>
#include <set>
#include <string>
#include <limits.h>

#if defined(WIN32)
#define snprintf _snprintf
#endif

using boost::filesystem::path;
using namespace std;

TEST(Empty, Empty)
{
}

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

    //Reuters21578() : keywords_(nullptr) {}

    virtual void SetUp()
    {
        // load keywords
        for (   char const *const *keyword_filename_fragment = &KEYWORD_FILES[0];
                *keyword_filename_fragment != NULL;
                ++keyword_filename_fragment)
        {
            string keyword_filename(string("all-") + *keyword_filename_fragment + "-strings.lc.txt");
            path keyword_filepath(path("reuters21578") / keyword_filename);
            std::cout << keyword_filepath << std::endl;
            // read the keyword file in text mode
            std::ifstream keyword_stream(keyword_filepath.string().c_str());
            // turn on all exceptions
            keyword_stream.exceptions(ifstream::badbit);
            while (keyword_stream.good())
            {
                string keyword;
                getline(keyword_stream, keyword);
                if (!keyword.empty())
                {
                    //std::cout << keyword << std::endl;
                    keywords_.push_back(keyword);
                }
            }
        }
        ASSERT_EQ(672, keywords_.size());
        hits_.resize(keywords_.size());
    }

    virtual void TearDown()
    {
        size_t total_hits = 0;
        for (   Hits::const_iterator hit_it(hits_.begin());
                hit_it != hits_.end(); ++hit_it)
        {
            total_hits += hit_it->size();
        }
        std::cout << "total hits: " << total_hits << std::endl;
    }

    inline Keywords const &keywords() const { return keywords_; }

    void search_wrapper(SearchInstance &search_function)
    {
        size_t bytes_searched = 0;
        for (int i = 0; i < 22; ++i)
        {
            char input_filename_fragment[4];
            ASSERT_EQ(3, snprintf(input_filename_fragment, sizeof(input_filename_fragment), "%03d", i));
            string input_filename(string("reut2-") + input_filename_fragment + ".sgm");
            path input_filepath = path("reuters21578") / input_filename;
            char buffer[0x200000];
            std::cout << input_filepath << std::endl;
            ifstream input_filestream(input_filepath.string().c_str());
            input_filestream.exceptions(ifstream::badbit);
            while (input_filestream.good())
            {
                input_filestream.read(buffer, sizeof(buffer));
                ASSERT_LT(input_filestream.gcount(), sizeof(buffer));
                buffer[input_filestream.gcount()] = '\0';
                ASSERT_EQ(input_filestream.gcount(), strlen(buffer));
                search_function(buffer, input_filestream.gcount(), bytes_searched, hits_);
                bytes_searched += input_filestream.gcount();
            }
        }
        ASSERT_EQ(27636766, bytes_searched);
    }

    Hits hits_;

private:
    Keywords keywords_;
    std::vector<std::vector<char> > haystacks_;
};

char const *const Reuters21578::KEYWORD_FILES[] = {"exchanges", "orgs", "people", "places", "topics", NULL};

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
                size_t offset = std::distance(buffer, where) + already;
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

class Horspool
{
public:
    Horspool(string pattern)
    :   m_(pattern.size()),
        d_(1 << CHAR_BIT, m_),
        p_(pattern)
    {
        for (int j = 1; j < m_; ++j)
        {
            d_.at(pattern.at(j - 1)) = m_ - j;
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
            while (j > 0 && tolower(buffer[pos + j - 1]) == tolower(p_.at(j - 1))) --j;
            if (j == 0) ASSERT_TRUE(hits.insert(pos + already).second);
            pos += d_.at(static_cast<char unsigned>(buffer[pos + m_ - 1]));
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

    virtual void operator()(char const *const buffer, size_t const length, size_t const already, Hits &hits)
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
