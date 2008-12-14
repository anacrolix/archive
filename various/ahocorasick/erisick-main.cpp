
#include <list>

#include "eri-corasick.h"
#include <iostream>

int main(int argc, char** argv)
{
    std::list<std::string> needles;
    std::list<std::pair<int, std::string> > results;


    needles.push_back("teletubby");
    needles.push_back("negro");
    needles.push_back("jesus");


    erisick c;
    c.add(needles);

    results = c.search("I went to the jesus store for some teletubbies and bumpted into a negro");

    for(std::list<std::pair<int, std::string> >::iterator r = results.begin();
        r != results.end();
        r++)
    {
        std::cout << "Found " << r->second << " at " << r->first << std::endl;
    }




    return (0);
}

