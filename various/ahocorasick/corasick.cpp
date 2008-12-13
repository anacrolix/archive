#include "corasick.h"

corasick::corasick()
{
    this->parent = NULL;
    this->fallback = NULL;
    this->end = false;

    for(int i = 0; i < (sizeof(char) * 256); i++)
    {
        kid[i] = NULL;
    }
}

void corasick::addFound(std::string s)
{   //should i check if it already exists?
    this->found.push_back(s);
}


void corasick::add(std::list<std::string> needles)
{

    for(std::list<std::string>::iterator word = needles.begin(); word != needles.end(); word++)
    {
        corasick *at = this;

        for(std::string::iterator c = word->begin(); c != word->end(); c++)
        {
            //corasick *newAt = NULL;
           // for(int i = 0; i < 255; i++)
           //{
           //     if(at->kid[i] == NULL)
           //         continue;
           //    if(at->kid[i]->payload == c)
           //     {
           //         newAt = at->kid;
           //        break;
           //     }
           // }

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

    std::list<corasick *> nodes; //a todo list of sort

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
        std::list<corasick *> newNodes; //for our next run, see end of code :D

        for(std::list<corasick *>::iterator node = nodes.begin(); node != nodes.end(); node++)
        {
            corasick *r = (*node)->parent->fallback;
            char c = (*node)->payload;

            while(r != NULL  && r->kid[c] == NULL)
                r = r->fallback;

            if(r==NULL) //can't be saved
                (*node)->fallback = this;
            else
            {
                (*node)->fallback = r->kid[c];
                for(std::list<std::string>::iterator f = (*node)->fallback->found->begin();
                f != (*node)->fallback->found->end(); f++)
                {
                    (*node)->addFound(*f);
                }
            }

            //give ourselves more work to do
            for(int i = 0; i < (sizeof(char) * 256); i++)
            {
                if((*node)->kid[i] != NULL)
                {
                    newNodes->pop_back((*node)->kid[i]);
                }

            }
            nodes = newNodes;
        }
    }
}

void corasick::add(char letter)
{
    kid[letter] = new corasick();
    kid[letter]->parent = this;
    kid[letter]->payload = letter;
}

std::list<std::pair<int, std::string> > corasick::search(std::string haystack)
{
    std::list<std::pair<int, std::string> > results;
    corasick *at = this;

    for(int i = 0; i < haystack.length() ; i++)
    {
        corasick * cor = NULL;
        while(cor == NULL)
        {
            cor = at->kid[haystack[i]];


            if (at == this) //no use for us
                break;

            if(cor == NULL) //didn't find
                *at = at->fallback; //and repeat
        }

        if(cor != NULL)
            at = cor;


        for(std::list<std::string>::iterator f = at->found->begin(); f != at->found->end(); f++)
        {
            std::pair<int, std::string> res(i, *f);
            results.push_back(res);
        }

    }

    return results;

}