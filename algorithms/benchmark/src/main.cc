#include <gtest/gtest.h>
#include <cassert>
#include <sstream>
#include <vector>

using namespace std;

size_t SGM_FILE_COUNT = 1;
vector<size_t> SGM_TOTAL_BYTES(22);

int main(int argc, char **argv)
{
    //testing::GTEST_FLAG(print_time) = true;
	testing::GTEST_FLAG(catch_exceptions) = true;
    testing::InitGoogleTest(&argc, argv);
    if (argc == 2)
    {
		std::stringstream ss(argv[1]);
		ss.exceptions(ios::badbit);
		ss >> SGM_FILE_COUNT;
		if (!ss.eof()) throw exception();
    }
    else assert(argc == 1);
    assert(SGM_FILE_COUNT >= 1 && SGM_FILE_COUNT <= 22);
    SGM_TOTAL_BYTES.at(0) = 1324350;
	SGM_TOTAL_BYTES.at(2) = 3796285;
    SGM_TOTAL_BYTES.at(21) = 27636766;
    int retcode = RUN_ALL_TESTS();
#ifdef WIN32
	system("pause");
#endif
	return retcode;
}
