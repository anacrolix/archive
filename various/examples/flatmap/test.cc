#include <gtest/gtest.h>

class FlatMapTest : public testing::Test
{
protected:
	FlatMapTest()
		:	expected(42)
	{
	}

	virtual ~FlatMapTest()
	{
		EXPECT_EQ(expected, result);
	}

	int result;

private:
	int const expected;
};

TEST_F(FlatMapTest, Correctness)
{
	result = 41;
}
