#include <algorithm>
#include <iostream>
#include <deque>

template<typename I, typename C, typename F>
F mem_fun_for_each(I first, I last, C me, F func)
{
	for (; first != last; ++first)
		(me->*func)(*first);
}

class A
{
public:
	typedef std::deque<int> Noob;

	A() {
		noob.push_back(3);
	}
	virtual ~A() {
		::mem_fun_for_each(noob.begin(), noob.end(), this, &A::show);
	}

	template<void (Noob::*T)(int const &)>
	void push(int i) {
		(noob.*T)(i);
	}
	inline void front(int i) { this->push<&Noob::push_front>(i); }
	inline void back(int i) { this->push<&Noob::push_back>(i); }

	static void (A::*front_)(int);
	static void (A::*back_)(int);
private:
	void show(int i) {
		std::cout << i << std::endl;
	}

	Noob noob;
};

void (A::*A::front_)(int)(&A::push<&Noob::push_front>);
void (A::*A::back_)(int)(&A::push<&Noob::push_back>);

int main()
{
	A a;
	(a.*A::back_)(4);
	(a.*A::front_)(2);
	a.front(1);
	a.back(5);

	return 0;
}
