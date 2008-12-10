#include "ahocorasick.hpp"

#include <set>
#include <string>
#include <vector>

#include <boost/assign/list_of.hpp>
#include <boost/assign/ptr_list_of.hpp>

using namespace std;
using namespace boost::assign;

class CStrKeyword : public Keyword<char const>
{
public:
	CStrKeyword(char const str[])
	:	string_(str),
		length_(strlen(str))
	{
	}
	virtual size_t size() const { return length_; }
	virtual char const &operator[](size_t index) const { return string_[index]; }
	virtual void debug_keyword() const { debug("\"%s\"", string_); }
	virtual void debug_symbol(size_t index) const { debug("\"%c\"", string_[index]); }
private:
	char const *string_;
	size_t length_;
};

class IntSetKeyword : public Keyword<set<int> >
{
};

bool test1()
{
	vector<Keyword<char const> *> kw;
	kw.push_back(new CStrKeyword("he"));
	kw.push_back(new CStrKeyword("she"));
	kw.push_back(new CStrKeyword("his"));
	kw.push_back(new CStrKeyword("hers"));
	AhoCorasick<char const> ac(kw.begin(), kw.end());

	return false;
}

bool test2()
{
	return false;
}

int main()
{
	test1();
	test2();

	return 0;
}
