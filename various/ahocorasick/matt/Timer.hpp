#pragma once

#include <cassert>
#include <iostream>
#include <ostream>
#include <string>

class Timer
{
	friend std::ostream & operator << (std::ostream & os, Timer & timer);

public:
	Timer(std::string const & what)
	:	what_(what)
	{
		restart();
	}

	void start()
	{
		if (start_ != -1) throw "Timer already started";
		start_ = xclock();
	}

	void pause()
	{
		if (start_ == -1) throw "Timer already paused";
		total_ += xclock() - start_;
		start_ = -1;
	}

	void reset()
	{
		start_ = -1;
		total_ = 0;
	}

	void restart()
	{
		reset();
		start();
	}

	bool is_paused()
	{
		return start_ == -1;
	}

private:
	inline clock_t xclock()
	{
		clock_t c = clock();
		assert(c != -1);
		return c;
	}

	std::string what_;
	clock_t total_;
	clock_t start_;
};

std::ostream & operator << (std::ostream & os, Timer & timer)
{
	bool paused(timer.is_paused());
	if (!paused) timer.pause();
	double passed = (double)timer.total_ / CLOCKS_PER_SEC;
	os << "[" << passed << "s] " << timer.what_;
	if (!paused) timer.start();
	return os;
}
