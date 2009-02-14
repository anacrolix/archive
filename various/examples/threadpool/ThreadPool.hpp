#include <boost/bind.hpp>
#include <boost/thread.hpp>

#include <deque>
#include <vector>

class Task
{
public:
	virtual void operator()() = 0;
};

class ThreadPool
{
public:
	ThreadPool(int nr_threads)
	:	threads_(nr_threads),
		finished_(false)
	{
		while (nr_threads-- > 0)
		{
			threads_.at(nr_threads) = new boost::thread(
					boost::bind(&ThreadPool::thread_func, boost::ref(*this)));
		}
	}

	~ThreadPool()
	{
		finished_ = true;
		tasks_cond_.notify_all();
		std::vector<boost::thread *>::iterator it;
		for (it = threads_.begin(); it != threads_.end(); ++it)
		{
			(*it)->join();
			delete *it;
		}
	}

	void add_task(Task *task)
	{
		{
			boost::lock_guard<boost::mutex> lock(tasks_mutex_);
			tasks_.push_back(task);
		}
		tasks_cond_.notify_one();
	}

	template <typename IterT>
	void add_tasks(IterT start, IterT const &end)
	{
		{
			boost::lock_guard<boost::mutex> lock(tasks_mutex_);
			while (start++ != end)
			{
				tasks_.push_back(*start);
			}
		}
		tasks_cond_.notify_all();
	}

protected:
	void thread_func()
	{
		while (true)
		{
			Task *task = NULL;
			{
				boost::unique_lock<boost::mutex> lock(tasks_mutex_);
				while (tasks_.empty()) {
					if (finished_) return;
					tasks_cond_.wait(lock);
				}
				task = tasks_.front();
				tasks_.pop_front();
			}
			//std::cout << "got task" << std::endl;
			(*task)();
		}
	}

private:
	std::vector<boost::thread *> threads_;
	boost::mutex tasks_mutex_;
	boost::condition_variable tasks_cond_;
	std::deque<Task *> tasks_;
	bool finished_;
};
