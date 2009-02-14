#include <iostream>

template <class DerivedT>
class HelloBase
{
public:
	void greet() {
		std::cout << "hello ";
		std::cout << static_cast<DerivedT *>(this)->who();
		std::cout << std::endl;
	}
};

class HelloWorld : public HelloBase<HelloWorld>
{
public:
	char const *who() { return "world"; }
};

class HelloCustom : public HelloBase<HelloCustom>
{
public:
	HelloCustom(char const *who) : who_(who) {}
	char const *who() { return who_; }

private:
	char const *who_;
};

int main()
{
	HelloWorld hw;
	hw.greet();
	HelloCustom hc("matt");
	hc.greet();
}
