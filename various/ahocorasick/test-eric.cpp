#include "erisick.h"
#include <stdlib.h>
#include <list>
#include <string>
#include <boost/assign/list_of.hpp>
#include "Timer.hpp"

using namespace std;
using namespace boost::assign;

void result_callback(string what, size_t where)
{
	cout << "[" << where << "]" << what.c_str() << endl;
}

int main()
{
	list<string> keywords = list_of("sex")("dick")("c++")("lol");
	for (int i = 10000; i < 100000; i++) {
		// no idea how to do this in fag++
		char buf[10];
		snprintf(buf, sizeof(buf), "%u", i);
		keywords.push_back(buf);
	}
	assert(keywords.size() == 90004);

	erisick eric();
	eric.add(keywords);
	char input[] = "ushers";
	//e.search(&input[0], &input[strlen(input)], result_callback);
#if 0
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
