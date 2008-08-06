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
		noob.push_back(2);
	}
	virtual ~A() {
		::mem_fun_for_each(noob.begin(), noob.end(), this, &A::show);
	}

	template<void (Noob::*T)(int const &)>
	void push(int i) {
		(noob.*T)(i);
	}

	static void (A::*front)(int);
	static void (A::*back)(int);
private:
	void show(int i) {
		std::cout << i << std::endl;
	}

	Noob noob;
};

void (A::*A::front)(int)(&A::push<&Noob::push_front>);
void (A::*A::back)(int)(&A::push<&Noob::push_back>);

int main()
{
	A a;
	(a.*A::back)(3);
	(a.*A::front)(1);
	return 0;
}
