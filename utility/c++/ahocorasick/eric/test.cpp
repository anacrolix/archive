#include "erisick.h"
#include "Timer.hpp"

#include <cstdio>

#include <fstream>
#include <iostream>
#include <set>
//#include <string>
//#include <typeinfo>
//#include <vector>

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

	void operator()(string what, size_t where)
	{
		if (!summary_)
			cerr << "[" << where << "]" << what << endl;
		else
			cerr << ".";
		//hits_[what].insert(where);
	}

	KeywordStoreT const &keywords_;
	vector<set<size_t> > hits_;
	bool summary_;
};



int main(int argc, char **argv)
{


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
		erisick *eri = new erisick();
                eri->add(file_kw);

		cerr << t << ": graph construction (" << file_kw.size() << " keywords)" << endl;

		Results<vector<string> > results(file_kw, true);
		ifstream input(argv[1], ifstream::binary);

		t.restart();
		while (input.good()) {
#if 1
			char buf[512];
			input.read(buf, 512);
			eri->search(buf + 0, buf + input.gcount(), results);
#else
			//char c = fag.get();
			//matt_ac.search(&c, &c + 1, results);
#endif
		}
		t.pause();
		cerr << endl;
		assert(input.is_open());
		input.clear();
		input.seekg(0, ios::end);
		int len = input.tellg();
		cerr << t << ": search " << len << " bytes" << endl;
	}
#endif
	return EXIT_SUCCESS;
}
