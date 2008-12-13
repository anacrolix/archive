#include "ahocorasick.hpp"

#include <cstdio>

#include <iostream>
#include <string>
#include <vector>

#include <boost/assign/list_of.hpp>

using namespace std;
using namespace boost::assign;

template <typename KeywordT>
struct Results
{
	template <typename KeywordIterT>
	Results(KeywordIterT const & begin, KeywordIterT const & end)
	:	keywords_(begin, end),
		hits_(distance(begin, end))
	{
	}

	void operator()(size_t where, size_t what)
	{
		cout << what << " : " << where << endl;
		assert(hits_[what].insert(where).second);
		cout << "offset: " << where << "; found: " << keywords_[what] << endl;
	}

	vector<KeywordT> keywords_;
	vector<set<size_t> > hits_;
};

int main()
{
	vector<string> const keywords = list_of("he")("she")("his")("hers");
	AhoCorasick<char> ac(keywords.begin(), keywords.end());
	char input[] = "ushers";
	Results<string> results(keywords.begin(), keywords.end());
	ac.search(&input[0], &input[sizeof(input)], results);
	vector<set<size_t> > const expected = list_of<set<size_t> >
			(list_of(3))
			(list_of(3))
			()
			(list_of(5));
	
	assert(expected == results.hits_);

	return 0;
}
