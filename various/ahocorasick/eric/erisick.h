#include <list>
#include <string>

class erisick
{
public:
	erisick();
	erisick(erisick *Parent);
	erisick(erisick *Parent, char c);

	void add(std::list<std::string> needles);

	void search(char *start, char *end, int (*callback)(std::string, size_t));

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
