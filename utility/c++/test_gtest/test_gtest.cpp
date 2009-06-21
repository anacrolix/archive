#include <gtest/gtest.h>
#include <iostream>

TEST(Gtest, Installed)
{
    std::cout << "Gtest is working." << std::endl;
    ASSERT_TRUE(true);
}
