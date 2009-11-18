#include "reuters.h"
#include "flags.h"
#include "xplatform.h"
#include <boost/filesystem.hpp>
#include <boost/numeric/conversion/cast.hpp>
#include <fstream>

using namespace std;
using namespace boost::filesystem;

char const *const Reuters21578::KEYWORD_FILES[] = {
    "exchanges", "orgs", "people", "places", "topics", NULL};

void Reuters21578::SetUp()
{
    // load keywords
    for (   char const *const *keyword_filename_fragment = &KEYWORD_FILES[0];
            *keyword_filename_fragment != NULL;
            ++keyword_filename_fragment)
    {
        string keyword_filename(string("all-") + *keyword_filename_fragment + "-strings.lc.txt");
        path keyword_filepath(path("reuters21578") / keyword_filename);
        //std::cout << keyword_filepath << std::endl;
        // read the keyword file in text mode
        ifstream keyword_stream(keyword_filepath.string().c_str());
        // turn on all exceptions
        // for some silly reason, turning on failbit on linux throws for no reason here
        keyword_stream.exceptions(ifstream::badbit /* | ifstream::failbit */);
        // so instead we check for fail here
        ASSERT_FALSE(keyword_stream.fail());
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
    hits_.resize(keywords_.size(), 0);
    //search_start_time_ = process_execution_time();
}

void Reuters21578::TearDown()
{
    ASSERT_EQ(expected_hit_count(), actual_hit_count());
    //std::cout << "total hits: " << actual_hit_count() << std::endl;
    cout << "search time: " << fixed << setprecision(2) << search_time_ << endl;
}

void Reuters21578::search_wrapper(SearchInstance &search_function)
{
    size_t bytes_searched = 0;
    search_time_ = 0.0;
    for (size_t i = 0; i < SGM_FILE_COUNT; ++i)
    {
        ostringstream input_filename_fragment;
        input_filename_fragment << std::setw(3) << std::setfill('0') << i;
        string input_filename(string("reut2-") + input_filename_fragment.str() + ".sgm");
        path input_filepath = path("reuters21578") / input_filename;
        vector<char> buffer(0x200000); // 2MiB
#if 0
        std::cout << input_filepath << std::endl;
#else
        std::cout << "." << std::flush; // required on linux?
#endif
        ifstream input_filestream(input_filepath.string().c_str());
        input_filestream.exceptions(ifstream::badbit);
        while (input_filestream.good())
        {
            input_filestream.read(&buffer[0], boost::numeric_cast<std::streamsize>(buffer.size()));
            ASSERT_LT(size_t(input_filestream.gcount()), buffer.size());
            buffer[input_filestream.gcount()] = '\0';
            ASSERT_EQ(input_filestream.gcount(), strlen(&buffer[0]));
            {
                double search_start_time = process_execution_time();
                search_function(&buffer[0], input_filestream.gcount(), bytes_searched, hits_);
                search_time_ += process_execution_time() - search_start_time;
            }
            bytes_searched += input_filestream.gcount();
        }
    }
    cout << endl;
    ASSERT_EQ(SGM_TOTAL_BYTES.at(SGM_FILE_COUNT - 1), bytes_searched);
}

size_t Reuters21578::expected_hit_count()
{
    vector<size_t> ehc(22);
    ehc.at(0) = 16193;
    ehc.at(2) = 45850;
    ehc.at(21) = 332056;
    return ehc.at(SGM_FILE_COUNT - 1);
}

size_t Reuters21578::actual_hit_count() const
{
    size_t total_hits = 0;
    for (   Hits::const_iterator hit_it(hits_.begin());
            hit_it != hits_.end(); ++hit_it)
    {
        total_hits += *hit_it;//->size();
    }
    return total_hits;
}

#if 0
class Empty : public Reuters21578
{
private:
    virtual void TearDown()
    {
        actual_hit_count();
        actual_hit_count();
    }
};

TEST_F(Empty, Empty)
{
}
#endif
