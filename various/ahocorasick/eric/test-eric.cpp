#include "erisick.h"

#include <iostream>

void write(std::string what, size_t pos)
{
	std::cout << "Found " << what << " at pos " << pos << std::endl;
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

	char *s = "I went to the jesus store for some negro teletubbies on a";

	void (*callbackwrite)(std::string, size_t) = NULL;
	callbackwrite = &write;

	eric->search((s+0), (s+70), callbackwrite);

	
    return 0;
}
