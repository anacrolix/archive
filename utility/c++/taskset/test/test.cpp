#include <iostream>
#include <boost/shared_ptr.hpp>
#include "TaskSet.hpp"

class Sum
{
public:
	Sum(int min, int max)
	:	min_(min),
		max_(max),
		total_(0),
		done_(false)
	{}

	void operator()()
	{
		assert(done_ == false);
		for (int cur = min_; cur <= max_; ++cur)
			total_ += cur;
		done_ = true;
	}

	int result() const
	{
		assert(done_ == true);
		return total_;
	}

private:
	int const min_, max_;
	int total_;
	bool done_;
};

int main()
{
	TaskSet<boost::shared_ptr<Sum> > taskset(10);
	std::deque<boost::shared_ptr<Sum> > sums;
	int step = 1000000;
	for (int min = 0; min < 4000000000; min += step)
		sums.push_back(boost::shared_ptr<Sum>(new Sum(min + 1, min + step)));
	taskset.add_tasks(sums.begin(), sums.end());
	taskset.wait_empty();
	int total = 0;
	for (std::deque<boost::shared_ptr<Sum> >::const_iterator it = sums.begin(); it != sums.end(); ++it)
		total += (*it)->result();
	std::cout << "total: " << total << "\n";
	assert(total == -475645216);
	system("pause");
	return 0;
}