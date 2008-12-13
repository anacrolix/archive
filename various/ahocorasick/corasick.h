#ifndef _CORASICK_H
#define	_CORASICK_H

#include <list>
#include <string>

class corasick {
public:
    corasick();
    corasick(corasick *parent);

    std::list<std::pair<int, std::string> > search(std::string haystack);

    corasick *parent;
    corasick *fallback;
private:
     corasick *find(char target);
     void add(char letter);
     void add(std::list<std::string> needles);
     void addFound(std::string s);
     
     std::list<std::string> found;
     bool end;
     corasick *kid[sizeof(char) * 256];
    //this can be removed in a future version
    //but it is because i'm lazy:
    char payload;

};





#endif	/* _CORASICK_H */

