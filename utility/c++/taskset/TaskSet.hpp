#include <boost/bind.hpp>
#include <boost/thread.hpp>

#include <deque>
// this header is only used for diagnostics
#include <iostream>

// (*TaskT)() is invoked, however this does not imply that TaskT need be a pointer
template <typename TaskT>
class TaskSet
{
public:
	// deque provides ordered FIFO semantics
	typedef typename std::deque<TaskT> TaskQueue_t;

	TaskSet(int nrthreads)
	:	finished_(false),
		barrier_(nrthreads)
	{
		while (nrthreads-- > 0) {
			threadgroup_.create_thread(boost::bind(
				&TaskSet::worker_func, // thread will have access to local data
				boost::ref(*this))); // use this object's context
		}
	}

	template <typename TASKITER>
	void add_tasks(TASKITER begin, TASKITER const &end)
	{
		boost::lock_guard<boost::mutex> guard(taskqueue_mutex_);
		for ( ; begin != end; ++begin)
		{
			taskqueue_.push_back(*begin);
		}
		// inside the lock to ensure all threads notified at once
		// some threads might pause incorrectly on the worker_func barrier
		// if they're not all fired at once?
		do_stuff_.notify_all();
	}

	void add_task(TaskT const &task)
	{
		this->add_tasks(&task, &task);
	}

	/** Wait for all tasks to be completed */
	void wait_empty()
	{
		boost::unique_lock<boost::mutex> tqlock(taskqueue_mutex_);
		while (taskqueue_.empty() == false)
			queue_empty_.wait(tqlock);
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
		// initialize all threads
		barrier_.wait();

		boost::unique_lock<boost::mutex> tqlock(taskqueue_mutex_);
		while (true)
		{
			while (taskqueue_.empty() == false)
			{
				TaskT task = taskqueue_.front();
				taskqueue_.pop_front();
				if (!(taskqueue_.size() % 1000)) std::cout << taskqueue_.size() << " tasks remain" << std::endl;
				tqlock.unlock();
				(*task)();
				tqlock.lock();
			}

			// this "flushes" all unlocked threads to complete task processing
			// otherwise we could notify queue empty while tasks are still be processed
			// we have to do this outside of a lock or we trap threads above and deadlock
			tqlock.unlock();
			if (barrier_.wait()) queue_empty_.notify_all();
			tqlock.lock();

			while (true)
			{
				if (!taskqueue_.empty()) break;
				if (finished_) {
					return;
				}
				do_stuff_.wait(tqlock);
			}
		}
	}

	TaskQueue_t taskqueue_; // FIFO task queue
	boost::mutex taskqueue_mutex_; // protect deque operations
	boost::thread_group threadgroup_; // thread container
	boost::condition_variable queue_empty_; // notified when queue empty and all tasks completed
	boost::condition_variable do_stuff_; // stuff has been added, or the taskset is being destroyed
	volatile bool finished_; // tells threads to return instead of wait
	boost::barrier barrier_; // used to sync task completion, and thread initialization
};
