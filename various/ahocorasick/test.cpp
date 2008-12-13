#include "ahocorasick.hpp"

#include <cstdio>

#include <iostream>
#include <string>
#include <vector>

#include <boost/assign/list_of.hpp>

using namespace std;
using namespace boost::assign;

template <typename KeywordStoreT>
struct Results
{
	Results(KeywordStoreT const & keywords)
	:	keywords_(keywords),
		hits_(keywords.size())
	{
	}

	void operator()(size_t what, size_t where)
	{
		cout << "[" << where << "]" << keywords_[what] << endl;
		hits_[what].insert(where);
	}

	KeywordStoreT const &keywords_;
	vector<set<size_t> > hits_;
};

typedef vector<set<size_t> > (*correctness_test)(vector<string> const &, char const *, char const *);

vector<set<size_t> >
matt_correctness(vector<string> const & keywords, char const *begin, char const *end)
{
	AhoCorasick<char> ac(keywords.begin(), keywords.end());
	Results <vector<string> > results(keywords);
	ac.search(begin, end, results);
	return results.hits_;
}

static vector<correctness_test> correctness_tests = list_of(matt_correctness);

int main()
{
	vector<string> const keywords = list_of("he")("she")("his")("hers");
	char const input[] = "ushers";
	vector<set<size_t> > const expected = list_of<set<size_t> >
			(list_of(3))
			(list_of(3))
			()
			(list_of(5));

	for (vector<correctness_test>::iterator it = correctness_tests.begin();
		it != correctness_tests.end(); ++it)
	{
		assert(expected == (**it)(keywords, &input[0], &input[sizeof(input)]));
	}

	return 0;
}
