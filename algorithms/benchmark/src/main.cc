#include <gtest/gtest.h>
#include <cassert>
#include <sstream>
#include <vector>

size_t SGM_FILE_COUNT = 1;
std::vector<size_t> SGM_TOTAL_BYTES(22);

int main(int argc, char **argv)
{
    testing::GTEST_FLAG(print_time) = true;
    testing::InitGoogleTest(&argc, argv);
    if (argc == 2)
    {
        std::stringstream(argv[1]) >> SGM_FILE_COUNT;
    }
    else assert(argc == 1);
    assert(SGM_FILE_COUNT >= 1 && SGM_FILE_COUNT <= 22);
    SGM_TOTAL_BYTES.at(0) = 1324350;
    SGM_TOTAL_BYTES.at(21) = 27636766;
    return RUN_ALL_TESTS();
}

TEST(Empty, Empty)
{
}

