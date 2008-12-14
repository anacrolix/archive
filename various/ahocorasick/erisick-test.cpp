#include "erisick-test.h"

#include <cassert>
#include <iostream>
#include <list>
#include <string>

#include "erisick.h"

using namespace std;

vector<set<size_t> >
eric_test_function(
		vector<string> const & keywords,
		char const *begin, char const *end)
{
	list<string> needles(keywords.begin(), keywords.end());
	erisick c;
	c.add(needles);
	typedef std::list<std::pair<int, std::string> > results_t;
	results_t results;
	results = c.search(string(begin));
	vector<set<size_t> > test_ret(keywords.size());
	for (	results_t::const_iterator res_it = results.begin();
			res_it != results.end();
			++res_it)
	{
		size_t what;
		for (what = 0; keywords[what] != res_it->second; what++);
		test_ret[what].insert(res_it->first);
		cout << "[" << res_it->first << "]" << keywords[what] << endl;
	}
	return vector<set<size_t> >();
}
