#include "AhoCorasick.hpp"
#include "Timer.hpp"


#include <cstdio>

#include <fstream>
#include <iostream>
#include <string>
#include <typeinfo>
#include <vector>

#include <boost/assign/list_of.hpp>


using namespace std;
using namespace boost::assign;

template <typename KeywordStoreT>
struct Results
{
	Results(KeywordStoreT const & keywords, bool summary = false)
	:	keywords_(keywords),
		hits_(keywords.size()),
		summary_(summary)
	{
	}

	void operator()(size_t what, size_t where)
	{
		if (!summary_)
			cerr << "[" << where << "]" << keywords_[what] << endl;
		else
			cerr << ".";
		hits_[what].insert(where);
	}

	KeywordStoreT const &keywords_;
	vector<set<size_t> > hits_;
	bool summary_;
};

typedef vector<set<size_t> > (*test_function_t)(vector<string> const &, char const *, char const *);

vector<set<size_t> >
matt_test_function(vector<string> const & keywords, char const *begin, char const *end)
{
	AhoCorasick<char> ac(keywords.begin(), keywords.end());
	Results <vector<string> > results(keywords);
	ac.search(begin, end, results);
	return results.hits_;
}

static vector<test_function_t> test_functions =
		list_of(&matt_test_function);

typedef struct {
	vector<string> keywords;
	char const *input;
	vector<set<size_t> > expected;
} TestData;

int main()
{
	TestData td[2];
	td[0].keywords = list_of("he")("she")("his")("hers");
	td[0].input = "ushers";
	td[0].expected = list_of<set<size_t> >(list_of(3))(list_of(3))()(list_of(5));
	td[1].keywords = list_of("she")("he")("hehe");
	td[1].input = "shehe";
	td[1].expected = list_of<set<size_t> >(list_of(2))(list_of(2)(4))(list_of(4));

	for (vector<test_function_t>::iterator it = test_functions.begin();
		it != test_functions.end(); ++it)
	{
		for (int i = 0; i < 2; i++)
		{
			if (td[i].expected == (**it)(
						td[i].keywords,
						&td[i].input[0],
						&td[i].input[strlen(td[i].input)]))
				cout << "*** Passed";
			else
				cout << "*** Failed";
			cout << endl;
		}
	}

#if 1
	{
		Timer t("performance test");

		vector<string> file_kw = list_of("sex")("dick")("c++")("lol");
		for (int i = 10000; i < 100000; i++) {
			char buf[10];
			snprintf(buf, sizeof(buf), "%u", i);
			file_kw.push_back(buf);
		}

		t.restart();
		AhoCorasick<char> matt_ac(file_kw.begin(), file_kw.end());
		cerr << t << ": graph construction (" << file_kw.size() << " keywords)" << endl;

		Results<vector<string> > results(file_kw, true);
		ifstream fag("input", ifstream::binary);

		t.restart();
		while (fag.good()) {
#if 1
			char buf[512];
			fag.read(buf, 512);
			matt_ac.search(buf, buf + fag.gcount(), results);
#else
			char c = fag.get();
			matt_ac.search(&c, &c + 1, results);
#endif
		}
		t.pause();
		cerr << endl;
		assert(fag.is_open());
		fag.clear();
		fag.seekg(0, ios::end);
		int len = fag.tellg();
		cerr << t << ": search " << len << " bytes" << endl;
	}
#endif
	return EXIT_SUCCESS;
}
