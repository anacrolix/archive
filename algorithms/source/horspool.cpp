#include "horspool.h"
#include <iostream>

using namespace std;

Horspool::Horspool(string const &pattern)
:   m_(pattern.size()),
    p_(pattern)
{
	//cout << pattern << endl;
    for (size_t j = 0; j < (1 << CHAR_BIT); ++j)
    {
        d_[j] = m_;
    }
    for (size_t j = 0; j < m_ - 1; ++j)
    {
        d_[static_cast<char unsigned>(pattern.at(j))] = m_ - j - 1;
    }
}

void Horspool::operator()(
        char const *const buffer,
        size_t const length, boost::function<void (size_t)> hits)
{
	//cout << buffer << endl;
	//cout << length << endl;
    char const *const end(buffer + length - m_ + 1);
    register char const *current(buffer);
    while (current < end)
    {
        register int j = m_ - 1;
        while (true)
        {
			//cout << current[j];
            if (j < 0)
            {
                hits(current - buffer);
            }
            else if (current[j] == p_[j])
            {
				//cout << " " << p_[j];
                --j;
                continue;
            }
            break;
        }
        //cout << " " << d_[static_cast<char unsigned>(current[m_ - 1])] << endl;
        current += d_[static_cast<char unsigned>(current[m_ - 1])];
    }
}
