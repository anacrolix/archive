#include <algorithm>
#include <iostream>
#include "ThreadPool.hpp"

boost::mutex cout_mutex;

template <typename T>
class PrintSomething : public Task
{
public:
	PrintSomething(T const &something)
	:	something_(something)
	{}

	virtual void operator()()
	{
		boost::lock_guard<boost::mutex> lock(cout_mutex);
		std::cout << something_ << std::endl;
	}

private:
	T const something_;
};

void f()
{
	std::vector<Task *> tasks;
	tasks.push_back(new PrintSomething<int>(1));
	tasks.push_back(new PrintSomething<char const *>("hi"));
	for (int i = 0; i < 10000; ++i)
	{
		tasks.push_back(new PrintSomething<int>(i));
	}

	ThreadPool tp(10);
	tp.add_tasks(tasks.begin(), tasks.end());

	//delete tasks[0];
}

int main()
{
	f();
	return 0;
}
