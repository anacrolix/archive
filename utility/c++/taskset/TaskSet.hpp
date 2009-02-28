#include <boost/bind.hpp>
#include <boost/thread.hpp>

#include <deque>
#include <iostream>

using namespace std;

template <typename TaskT>
class TaskSet
{
public:
	typedef typename std::deque<TaskT> TaskQueue_t;

	TaskSet(/*TaskQueue_t const &taskqueue, */int nrthreads)
	://	taskqueue_(taskqueue),
		finished_(false),
		barrier_(nrthreads)
	{
		while (nrthreads-- > 0)
			threadgroup_.create_thread(boost::bind(&TaskSet::worker_func, boost::ref(*this)));
	}

	template <typename TASKITER>
	void add_tasks(TASKITER begin, TASKITER const &end)
	{
		taskqueue_mutex_.lock();
		for ( ; begin != end; ++begin)
		{
			taskqueue_.push_back(*begin);
		}
		do_stuff_.notify_all();
		taskqueue_mutex_.unlock();
	}

	void wait_empty()
	{
		taskqueue_mutex_.lock();
		while (taskqueue_.empty() == false)
			queue_empty_.wait(taskqueue_mutex_);
		taskqueue_mutex_.unlock();
	}

	~TaskSet()
	{
		finished_ = true;
		do_stuff_.notify_all();
		threadgroup_.join_all();
	}

private:
	void worker_func()
	{
		barrier_.wait();
		taskqueue_mutex_.lock();
		while (true)
		{
			TaskT task;
			while (taskqueue_.empty() == false)
			{
				task = taskqueue_.front();
				taskqueue_.pop_front();
				if (!(taskqueue_.size() % 1000)) cout << taskqueue_.size() << " tasks remain" << endl;
				taskqueue_mutex_.unlock();
				(*task)();
				taskqueue_mutex_.lock();
			}
			taskqueue_mutex_.unlock();
			if (barrier_.wait()) queue_empty_.notify_all();
			taskqueue_mutex_.lock();
			while (true)
			{
				if (!taskqueue_.empty()) continue;
				if (finished_) {
					taskqueue_mutex_.unlock();
					return;
				}
				do_stuff_.wait(taskqueue_mutex_);
			}
		}
	}

	TaskQueue_t taskqueue_;
	boost::mutex taskqueue_mutex_;
	boost::thread_group threadgroup_;
	boost::condition_variable_any queue_empty_;
	boost::condition_variable_any do_stuff_;
	volatile bool finished_;
	boost::barrier barrier_;
};
