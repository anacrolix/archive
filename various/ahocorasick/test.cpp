#include "ahocorasick.hpp"

//#include <fcntl.h>

#include <fstream>
#include <iostream>
#include <set>
#include <string>
#include <vector>

#include <boost/assign/list_of.hpp>
#include <boost/assign/ptr_list_of.hpp>

using namespace std;
using namespace boost::assign;
using namespace AC;

class CStrKeyword : public Keyword<char>
{
public:
	CStrKeyword(char const str[])
	:	string_(str),
		length_(strlen(str))
	{
	}
	virtual size_t size() const { return length_; }
	virtual char const &operator[](size_t index) const { return string_[index]; }
#if !defined(NDEBUG)
	virtual void debug_keyword() const {
		debug("\"%s\"", string_);
	}
	virtual void debug_symbol(size_t index) const {
		debug("\"%c\"", string_[index]);
	}
#endif
private:
	char const *string_;
	size_t length_;
};

class WideStrKeyword : public Keyword<wchar_t>
{
public:
	WideStrKeyword(wchar_t const str[])
	:	string_(str),
		length_(wcslen(str))
	{
	}
	virtual size_t size() const { return length_; }
	virtual wchar_t const &operator[](size_t index) const { return string_[index]; }
#if !defined(NDEBUG)
	virtual void debug_keyword() const {
		wdebug(L"\"%s\"", string_);
	}
	virtual void debug_symbol(size_t index) const {
		wdebug(L"\"%c\"", string_[index]);
	}
#endif
private:
	wchar_t const *string_;
	size_t length_;
};

class CStrHaystack : public Haystack<char>
{
public:
	CStrHaystack(char const hay[])
	:
		hay_(hay)
	{}

	virtual bool at(size_t offset, char const *&input)
	{
		if (offset < strlen(hay_)) {
			input = &hay_[offset];
			return true;
		}
		else
			return false;
	}
private:
	char const *hay_;
};

class BinaryFileHaystack : public Haystack<char>
{
public:
	BinaryFileHaystack(char const *filename)
	:	Haystack<char>()
	{
		ifs_.open(filename);
	}
	~BinaryFileHaystack()
	{
		ifs_.close();
	}

	virtual bool at(size_t offset, char const *&input)
	{
		if (ifs_.good()) {
			ifs_.get(buf_);
			input = &buf_;
			return true;
		}
		else
			return false;
	}

private:
	ifstream ifs_;
	mutable char buf_;
};

static void print_hit(size_t index, Keyword<char> const *keyword)
{
	debug("Found hit [%zu]: ", index);
	keyword->debug_keyword();
	debug("\n");
}

bool test1()
{
	vector<Keyword<char> *> kw;
	kw.push_back(new CStrKeyword("he"));
	kw.push_back(new CStrKeyword("she"));
	kw.push_back(new CStrKeyword("his"));
	kw.push_back(new CStrKeyword("hers"));

	CStrHaystack hay("ushers");

	AhoCorasick<char> ac(kw.begin(), kw.end());
	ac(hay, print_hit);
	ac(hay, print_hit);

	return false;
}

bool test2(char const *filename)
{
	vector<Keyword<char> *> kw;
	kw.push_back(new CStrKeyword("vector"));
	kw.push_back(new CStrKeyword("vec"));
	kw.push_back(new CStrKeyword("vecna"));
	//kw.push_back(new CStrKeyword("mage"));
	kw.push_back(new CStrKeyword("fighter"));
	kw.push_back(new CStrKeyword("god"));
	kw.push_back(new CStrKeyword("sword"));
	kw.push_back(new CStrKeyword("spell"));
	kw.push_back(new CStrKeyword("body"));
	kw.push_back(new CStrKeyword("matt"));
	kw.push_back(new CStrKeyword("04"));
	kw.push_back(new CStrKeyword("table"));
	kw.push_back(new CStrKeyword("and"));
	//kw.push_back(new CStrKeyword("x"));

	vector<Keyword<wchar_t> *> kw2;
	kw2.push_back(new WideStrKeyword(L"hi"));

	BinaryFileHaystack hay(filename);
	AhoCorasick<char> ac(kw.begin(), kw.end());
	ac(hay, print_hit);

	return false;
}

int main(int argc, char **argv)
{
	test1();
	test2(argv[1]);

	return 0;
}
