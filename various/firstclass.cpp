#include <stdio.h>
#include <vector>

using namespace std;

class C
{
public:
	int operator()(int *d)
	{
		return *d;
	}
};

int cb(int *d)
{
	return *d;
}

template <typename F>
void test(F &f)
{
	int d = 2;
	printf("%d\n", f(&d));
}

bool test2(char *s)
{
	printf("%s\n", s);
	return true;
}

int main()
{
	C c;
	test(c);
	vector<char *> str;
	str.push_back("hello");
	test2(*str.begin());
}
