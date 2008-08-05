#include <algorithm>
#include <iostream>
#include <deque>

void show(int i) {
	std::cout << i << std::endl;
}

class A
{
public:
	A() {
		noob.push_back(2);
	}
	virtual ~A() {
		std::for_each(noob.begin(), noob.end(), show);
	}
		
	template<void (std::deque<int>::*T)(int const &)>
	void push(int i) {
		(noob.*T)(i);
	}
	static void (A::*front)(int);
	static void (A::*back)(int);
private:
	std::deque<int> noob;
};

void (A::*A::front)(int)(&A::push<&std::deque<int>::push_front>);
void (A::*A::back)(int)(&A::push<&std::deque<int>::push_back>);

int main()
{
	A a;
	(a.*A::back)(3);
	(a.*A::front)(1);
	return 0;
}

