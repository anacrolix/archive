#include "erisick.h"

erisick::erisick()
{
    this->parent = NULL;
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


void erisick::add(std::list<std::string> needles)
{

    for(std::list<std::string>::iterator word = needles.begin(); word != needles.end(); word++)
    {
        erisick *at = this;

        for(std::string::iterator c = word->begin(); c != word->end(); c++)
        {
            if(at->kid[*c] == NULL)
            {
                at->add(*c);
            }
            at = at->kid[*c];
        }
        at->end = true; //end of a word :D
        at->addFound(*word);

    }

    //time to make fall backs. fuck fuck fuck
    this->fallback = this; //that was easy ;D

    std::list<erisick *> nodes; //a todo list of sort

    //well, here's the easy part. All immediate kiddies
    //will fall back to root
    for(int i = 0; i < (sizeof(char) * 256); i++)
    {
        if(this->kid[i] == NULL)
            break; //nothing to be done
        this->kid[i]->fallback = this;
        //let's add it, and its kiddies to our todo
        for(int j = 0; j < (sizeof(char) * 256); j++)
        {
            if(this->kid[i]->kid[j] != NULL)
                nodes.push_back(this->kid[i]->kid[j]);
        }
    }

    //ok, now to the fucked up shit.
    while(nodes.empty() == false)
    {
        std::list<erisick *> newNodes; //for our next run, see end of code :D

        for(std::list<erisick *>::iterator node = nodes.begin(); node != nodes.end(); node++)
        {
            erisick *r = (*node)->parent->fallback;
            char c = (*node)->payload;

            while(r != NULL  && r->kid[c] == NULL)
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
            nodes = newNodes;
        }
    }
}

void erisick::add(char letter)
{
    kid[letter] = new erisick();
    kid[letter]->parent = this;
    kid[letter]->payload = letter;
}

std::list<std::pair<int, std::string> > erisick::search(std::string haystack)
{
    std::list<std::pair<int, std::string> > results;
    erisick *at = this;

    for(int i = 0; i < haystack.length() ; i++)
    {
        erisick * cor = NULL;
        while(cor == NULL)
        {
            cor = at->kid[haystack[i]];


            if (at == this) //no use for us
                break;

            if(cor == NULL) //didn't find
                at = at->fallback; //and repeat
        }

        if(cor != NULL)
            at = cor;


        for(std::list<std::string>::iterator f = at->found.begin(); f != at->found.end(); f++)
        {
            std::pair<int, std::string> res(i, *f);
            results.push_back(res);
        }

    }

    return results;

}