#include <boost/thread.hpp>
#include <deque>

template <typename TaskT>
class TaskSet
{
public:
	typedef typename std::deque<TaskT> TaskQueue_t;

	TaskSet(TaskQueue_t const &taskqueue, int nrthreads)
	:	taskqueue_(taskqueue)
	{
		while (nrthreads-- > 0)
			threadgroup_.create_thread(boost::bind(&TaskSet::worker_func, boost::ref(*this)));
	}

	~TaskSet()
	{
		threadgroup_.join_all();
	}

private:
	bool get_task(TaskT &task)
	{
		boost::lock_guard<boost::mutex> guard(taskqueue_mutex_);
		if (taskqueue_.empty())
			return false;
		else {
			task = taskqueue_.front();
			taskqueue_.pop_front();
			return true;
		}
	}

	void worker_func()
	{
		TaskT task;
		while (get_task(task))
		{
			(*task)();
		}
	}

	TaskQueue_t taskqueue_;
	boost::mutex taskqueue_mutex_;
	boost::thread_group threadgroup_;
};
