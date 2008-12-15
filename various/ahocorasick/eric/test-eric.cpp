#include "erisick.h"

#include <iostream>

void write(std::string what, size_t where)
{
	std::cout << "Found " << what << " at pos " << where;
} 

int main(int argc, char** argv)
{
    std::list<std::string> needles;

    needles.push_back("teletubby");
    needles.push_back("negro");
    needles.push_back("jesus");


    erisick *eric = new erisick();


	//expensive build
    eric->add(needles);

	char *s = "I went to the jesus store for some teletubbies and bumpted into a negro";

	//eric->search((s+0), (s+70), &write);

	
    return 0;
}
