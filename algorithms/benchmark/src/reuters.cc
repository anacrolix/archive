#include "reuters.hh"
#include "flags.hh"
#include <boost/filesystem.hpp>
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

void Reuters21578::TearDown()
{
    size_t total_hits = 0;
    for (   Hits::const_iterator hit_it(hits_.begin());
            hit_it != hits_.end(); ++hit_it)
    {
        total_hits += hit_it->size();
    }
    std::cout << "total hits: " << total_hits << std::endl;
}

void Reuters21578::search_wrapper(SearchInstance &search_function)
{
    size_t bytes_searched = 0;
    for (size_t i = 0; i < SGM_FILE_COUNT; ++i)
    {
        char input_filename_fragment[4];
        ASSERT_EQ(3, snprintf(input_filename_fragment, sizeof(input_filename_fragment), "%03zu", i));
        string input_filename(string("reut2-") + input_filename_fragment + ".sgm");
        path input_filepath = path("reuters21578") / input_filename;
        char buffer[0x200000]; // 2MiB
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
    ASSERT_EQ(SGM_TOTAL_BYTES.at(SGM_FILE_COUNT - 1), bytes_searched);
}
