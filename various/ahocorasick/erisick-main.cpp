#include <list>

#include "erisick.h"
#include <iostream>
#include "string.h"


int main(int argc, char** argv)
{
    std::list<std::string> needles;
    std::list<std::pair<int, std::string> > results;


    needles.push_back("teletubby");
    needles.push_back("negro");
    needles.push_back("jesus");


    erisick c;
    c.add(needles);
    
    char *search = "I went to the jesus store for some teletubbies and bumpted into a negro";

    /*results = c.search((search+0), strrchr(search, '\0' ));

    for(std::list<std::pair<int, std::string> >::iterator r = results.begin();
        r != results.end();
        r++)
    {
        std::cout << "Found " << r->second << " at " << r->first << std::endl;
    }*/

    return (0);
}
