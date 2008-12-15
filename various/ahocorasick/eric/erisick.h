#pragma once

#include <fstream>
#include <list>
#include <string>

class erisick
{
public:
	erisick();
	erisick(erisick *Parent);
	erisick(erisick *Parent, char c);
	void add(std::list<std::string> needles);

	template <typename CallbackT>
	void search(char *start, char *end, CallbackT & callback)
	{
		std::list<std::pair<int, std::string> > results;
		erisick *at = this;

		for(char *i = start; i < end ; i++)
		{
			erisick *cor = NULL;
			while(cor == NULL)
			{
				cor = at->kid[*i];

				if (at == this) //no use for us
					break;

				if(cor == NULL) //didn't find
					at = at->fallback; //and repeat
			}

			if(cor != NULL)
				at = cor;


			for(std::list<std::string>::iterator f = at->found.begin(); f != at->found.end(); f++)
			{
				size_t where = i-start;
				//*f is the std::string we found
				callback(where, *f); 
			}

		}

	}

	erisick *parent;
	erisick *fallback;
private:
	erisick *find(char target);
	//void add(char letter);
	void init();

	void addFound(std::string s);

	std::list<std::string> found;
	bool end;
	erisick *kid[sizeof(char) * 256];
	//this can be removed in a future version
	//but it is because i'm lazy:
	char payload;
};
