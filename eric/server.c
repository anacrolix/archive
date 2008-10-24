#include <stdio.h> 
#include <stdlib.h> 
#include <errno.h> 
#include <string.h> 
#include <sys/types.h> 
#include <netinet/in.h> 
#include <sys/socket.h> 
#include <sys/wait.h> 

#include "threadpool.h" //threadpool goodness

threadpool tp;


#define MYPORT 54321    /* the port users will be connecting to */


char *getDefinition(char *word); //handy function at end of code
void ProcessRequest(void *fd); //no headers for me >: D

int main(int argc, char** argv)
{

    int sockfd, new_fd;  /* listen on sock_fd, new connection on new_fd */
    struct sockaddr_in my_addr;    /* my address information */
    struct sockaddr_in their_addr; /* connector's address information */
    int sin_size;

	tp = create_threadpool(10); //i'd like to see anyone try even use all 10 lol


/* generate the socket */
    if ((sockfd = socket(AF_INET, SOCK_STREAM, 0)) == -1) {
        perror("socket");
        exit(1);
    }

/* generate the end point */
    my_addr.sin_family = AF_INET;         /* host byte order */
    my_addr.sin_port = htons(MYPORT);     /* short, network byte order */
    my_addr.sin_addr.s_addr = INADDR_ANY; /* auto-fill with my IP */
    /* bzero(&(my_addr.sin_zero), 8);   ZJL*/     /* zero the rest of the struct */

/* bind the socket to the end point */
    if (bind(sockfd, (struct sockaddr *)&my_addr, sizeof(struct sockaddr)) == -1)
    {
        perror("bind");
        exit(1);
    }

/* start listnening */
    if (listen(sockfd, 10) == -1) //backlog upto 10
	{
        perror("listen");
        exit(1);
    }

     printf("We're ready to accept client connections ...\n");

/* repeat: accept, send, close the connection */
/* for every accepted connection, use a sepetate process or thread to serve it */
    while(1) /* main accept() loop */
    {  
        sin_size = sizeof(struct sockaddr_in);
        if ((new_fd = accept(sockfd, (struct sockaddr *)&their_addr, &sin_size)) == -1)
        {
            perror("accept");
            continue;
        }
        printf("Yay! Someone has connected. They have done so from %s\n", inet_ntoa(their_addr.sin_addr));
		dispatch(tp, ProcessRequest, (void *) new_fd); //give to our thread pool to do..

    }

	//if we ever break out, we'll clean up ;D
	destroy_threadpool(tp);

}

void ProcessRequest(void *fd)
{
	int new_fd = (int) fd;
	int numbytes;
	char buf[5000]; //complain to someone who cares :P
	//listen to what the client says..
	if ((numbytes=recv(new_fd, buf, 5000, 0)) == -1) {
		perror("recv");
		exit(1);
	}

	buf[numbytes] = '\0';

	printf("The client has asked us to look up %s\n",buf);

	//ok, let's look up the word they wanted
	char *def = getDefinition(buf);

	if(def == NULL)
	{
		def = "Could not find word";
		printf("We could not find the definition\n");
	}
	else
	{
		printf("Definition Found\n");
	}


	if (send(new_fd, def, (strlen(def) + 1), 0) == -1)
		perror("send");


	close(new_fd);
}




//put your seat belt on.
//no, seriously do it
//this is one hell of a function :/
char *getDefinition(char *word)
{
	FILE *file = fopen("dictionary.txt", "r");

	enum DIC_STATUS
	{
		DIC_NOTHING,
		DIC_WORD,
		DIC_DEFINITION
	} dic_status;

	dic_status = DIC_NOTHING;

	/* fopen returns 0, the NULL pointer, on failure */
	if ( file == 0 )
	{
		printf( "Could not open file\n" );
		return NULL;
	}

	int x;
	int atCorrectWord = 0; //a boolean
	char *defBuffer = malloc(5000); //that'll do us
	char *wordBuffer = malloc(500);
	while  ( ( x = fgetc( file ) ) != EOF )
	{
		if(x == '@') //this is like a state change
		{
			if(dic_status == DIC_NOTHING)
			{
				dic_status = DIC_WORD;
				wordBuffer[0] = '\0';
			}
			else if(dic_status == DIC_WORD)
			{
				if(strncmp(wordBuffer, word, 500) == 0) //zero is match
				{
					atCorrectWord = 1;
				}
				else
				{
					atCorrectWord = 0;
				}
				
				defBuffer[0] = '\0';
				wordBuffer[0] = '\0';
				dic_status = DIC_DEFINITION;
			}
			else
			{
				printf( "Error: messed up dictionary (invalid placement of an @).." );
				return NULL;
			}
		}
		else if(x == '\n')
		{
			if(dic_status == DIC_DEFINITION) //end the definition
			{
				//if we were processing the shitiz
				if(atCorrectWord)
				{
					return defBuffer;
				}
				dic_status = DIC_NOTHING;
			}
			else
			{
				printf("Error: there shouldn't be a newline here");
				return NULL;
			}
		}
		else // a normal char
		{
			if(dic_status == DIC_WORD)
			{
				int len = strlen(wordBuffer);
				wordBuffer[len] = (char) x;
				wordBuffer[len+1] = '\0';
			}
			else if (dic_status == DIC_DEFINITION)
			{
				//but we only give a shit, if we're at the correct word
				if(atCorrectWord)
				{
					int len = strlen(defBuffer);
					defBuffer[len] = (char) x;
					defBuffer[len+1] = '\0';
				}
			}
			else
			{
				printf("wtf, why normal char ..");
				return NULL;
			}

		}

	}

	fclose( file );
	return NULL;
}
//thank GOD that's over
//if i need to write any more of this
//i'm going to start killing babies
