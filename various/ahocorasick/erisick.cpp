#include "erisick.h"


erisick::erisick(erisick *Parent, char c)
: parent(Parent)
{
	init();
	kid[c] = new erisick(this);
	this->payload = c;
}

erisick::erisick(erisick *Parent)
: parent(Parent)
{
	init();
	this->payload = ' ';
}

erisick::erisick()
: parent(NULL)
{
	init();
	this->payload = ' ';
}

void erisick::init()
{
	this->fallback = NULL;
    this->end = false;
	for(int i = 0; i < (sizeof(char) * 256); i++)
    {
        kid[i] = NULL;
    }
}




void erisick::addFound(std::string s)
{   //should i check if it already exists?
    this->found.push_back(s);
}


void erisick::add(std::list<std::string> Needles)
{
	if(!needles.empty())
		throw 2; //you can not call add twice, yet.
	needles = Needles;
	
    for(std::list<std::string>::iterator word = Needles.begin(); word != Needles.end(); word++)
    {
        erisick *at = this;

        for(std::string::iterator c = word->begin(); c != word->end(); c++)
        {
            if(at->kid[*c] == NULL)
            {
                erisick* add = new erisick(at, *c);
				at->kid[*c] = add;
            }
            at = at->kid[*c];
        }
        at->end = true; //end of a word :D
        at->addFound(*word);

    }

    //time to make fall backs. fuck fuck fuck
    

    std::list<erisick *> nodes; //a todo list of sort

    //well, here's the easy part. All immediate kiddies
    //will fall back to root
    for(int i = 0; i < (sizeof(char) * 256); i++)
    {
        if(this->kid[i] == NULL)
            continue; //nothing to be done
        this->kid[i]->fallback = this;
        //let's add it, and its kiddies to our todo
        for(int j = 0; j < (sizeof(char) * 256); j++)
        {
            if(this->kid[i]->kid[j] != NULL)
                nodes.push_back(this->kid[i]->kid[j]);
        }
    }

	std::list<erisick *> newNodes; //for our next run, see end of code :D
    //ok, now to the fucked up shit.
    while(nodes.empty() == false)
    {
        

        for(std::list<erisick *>::iterator node = nodes.begin(); node != nodes.end(); node++)
        {
            erisick *r = (*node)->parent->fallback;
			char c = (*node)->payload;

            while(r != NULL && r->kid[c] == NULL)
                r = r->fallback;

            if(r==NULL) //can't be saved
                (*node)->fallback = this;
            else
            {
                (*node)->fallback = r->kid[c];
                for(std::list<std::string>::iterator f = (*node)->fallback->found.begin();
                f != (*node)->fallback->found.end(); f++)
                {
                    (*node)->addFound(*f);
                }
            }

            //give ourselves more work to do
            for(int i = 0; i < (sizeof(char) * 256); i++)
            {
                if((*node)->kid[i] != NULL)
                {
                    newNodes.push_back((*node)->kid[i]);
                }

            }
            
        }
		nodes.clear();
		for(std::list<erisick *>::iterator n = newNodes.begin(); n != newNodes.end(); n++)
			nodes.push_back(*n);
		newNodes.clear();

    }
	this->fallback = this; //that was easy ;D
}

//void erisick::add(char letter)
//{
//    kid[letter] = new erisick();
//    kid[letter]->parent = this;
//    kid[letter]->payload = letter;
//}

template <typename CallbackT>
void erisick::search(char *start, char *end, CallbackT & callback)
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
            //f is the word we found
            //*i is it's position
            size_t where = i-start;
            
            for(std::list<std::string>::iterator what = this->needles.begin();
            what != this->needles.end(); what++)
            {
            	callback(*what, where);
			}
            
        }

    }

}
