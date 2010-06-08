#include <stdio.h>
#include <string.h>
#include <stdlib.h>
/* 
   OFFSET_1 is login0\d\.tibia\.com
   OFFSET_2 is tibia0\d\.cipsoft\.com
*/

#ifdef WIN32
#include <winsock2.h>
#define TIBIA_EXE_NAME "Tibia.exe"
#define PUBLIC_KEY_EXE_OFFSET 0x193610
#define LOGIN_HOSTS_OFFSET_1 0x1a836c
#define LOGIN_HOSTS_SIZE_1 20
#define LOGIN_HOSTS_COUNT_1 5
#define LOGIN_HOSTS_OFFSET_2 0x1a8308
#define LOGIN_HOSTS_SIZE_2 20
#define LOGIN_HOSTS_COUNT_2 5
#else 
#include <netdb.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#define TIBIA_EXE_NAME "Tibia"
#define PUBLIC_KEY_EXE_OFFSET 0x474cc0
#define LOGIN_HOSTS_OFFSET_1 0x4751dc
#define LOGIN_HOSTS_SIZE_1 18
#define LOGIN_HOSTS_COUNT_1 5
#define LOGIN_HOSTS_OFFSET_2 0x475236
#define LOGIN_HOSTS_SIZE_2 20
#define LOGIN_HOSTS_COUNT_2 5
#endif

#define IP_BUF_SIZE 16 //max size "xxx.xxx.xxx.xxx\0"
#define MY_EXE_NAME "eruipchg" 

const char CORRECT_USAGE[] =
"Usage: " MY_EXE_NAME " [otserv host]\n"
"If otserv host is not provided, the exe will be configured for the default tibia servers.\n";

const char TIBIA_PUBLIC_KEY[] = 
"124710459426827943004376449897985582167801707960697037164044904862948569380850421396904597686953877022394604239428185498284169068581802277612081027966724336319448537811441719076484340922854929273517308661370727105382899118999403808045846444647284499123164879035103627004668521005328367415259939915284902061793";

const char OT_PUBLIC_KEY[] = 
"109120132967399429278860960508995541528237502902798129123468757937266291492576446330739696001110603907230888610072655818825358503429057592827629436413108566029093628212635953836686562675849720620786279431090218017681061521755056710823876476444260558147179707119674283982419152118103759076030616683978566631413";

void print_usage() {
  printf(CORRECT_USAGE);
  return;
}

char *hostname_to_ascii_ip(char *hostname) {
  struct hostent *he;
  char *ascii_ip;
#ifdef _WIN32
  WSADATA wsa_Data;
  int wsa_ReturnCode = WSAStartup(0x101,&wsa_Data);
#endif
  he = gethostbyname(hostname);
  if (he == NULL) {
    perror("Failed to resolve hostname");
    return NULL;
  }
  ascii_ip = malloc(IP_BUF_SIZE);
  if (ascii_ip == NULL) {
    perror("Unable to allocate memory to hold ascii IP");
    return NULL;
  }
  //szLocalIP = inet_ntoa (*(struct in_addr *)*host_entry->h_addr_list);
  //ascii_ip = inet_ntoa(*(struct in_addr *)*he->h_addr_list);
  ascii_ip = inet_ntoa(*(struct in_addr *)he->h_addr);
  if (ascii_ip == NULL) {
    perror("Failed to convert network address to ascii IP");
    return NULL;
  } 
  return ascii_ip;
}

int main(int argc, char **argv) {
  char *ot_login_host = NULL;
  char *ot_login_ip = NULL; //xxx.xxx.xxx.xxx\0

  //check if we want cipsoft server or an otserv
  if (argc == 2) {
    ot_login_host = argv[1];
  } else if (argc > 2 || argc < 1) {
    print_usage();
    return 1;
  }
  //resolve ot host name
  if (ot_login_host) ot_login_ip = hostname_to_ascii_ip(ot_login_host);
  printf("%s gave address %s\n", ot_login_host, ot_login_ip);
  //open tibia executable for read/write
  FILE *fh_tibia;
  fh_tibia = fopen(TIBIA_EXE_NAME, "r+");
  if (fh_tibia == NULL) {
    perror("Can't open executable for read/write");
    return 1;
  }
  //get and determine what the existing RSA key is
  if (fseek(fh_tibia, PUBLIC_KEY_EXE_OFFSET, SEEK_SET) != 0) {
    perror("Can't seek to RSA offset");
    return 1;
  }
  printf("sizeof(TIBIA_PUBLIC_KEY) == %d\n", sizeof(TIBIA_PUBLIC_KEY));
  char cur_rsa_key[sizeof(TIBIA_PUBLIC_KEY)];
  if (fgets(cur_rsa_key, sizeof(cur_rsa_key), fh_tibia) == NULL) {
    perror("Unable to copy RSA key from executable");
    return 1;
  }
  printf("Existing public key: %s\n", cur_rsa_key);
  if (strcmp(cur_rsa_key, TIBIA_PUBLIC_KEY) == 0) {
    printf("Existing key is for official Tibia servers\n");
  } else if (strcmp(cur_rsa_key, OT_PUBLIC_KEY) == 0) {
    printf("Existing key is for OT servers\n");
  } else {
    printf("Unknown RSA key detected!\n");
    return 1;
  }
  //write new RSA key (could be moved into section above)
  fseek(fh_tibia, PUBLIC_KEY_EXE_OFFSET, SEEK_SET);
  if (fputs((ot_login_host) ? OT_PUBLIC_KEY : TIBIA_PUBLIC_KEY,
	    fh_tibia)
      == EOF) {
    perror("Couldn't write new public key to file");
    return 1;
  }
  printf("Wrote appropriate public key to executable\n");
  //write server addresses
  int i;
  for (i = 0; i < LOGIN_HOSTS_COUNT_1; i++) {
    fseek(fh_tibia, LOGIN_HOSTS_OFFSET_1+i*LOGIN_HOSTS_SIZE_1, SEEK_SET);
    if (ot_login_host) {
      fwrite(ot_login_ip, sizeof(char), strlen(ot_login_ip)+1, fh_tibia);
    } else {
      fprintf(fh_tibia, "login0%d.tibia.com", 
#ifdef WIN32
	      5-i
#else
	      i+1
#endif
	      );
    }
  }
  for (i = 0; i < LOGIN_HOSTS_COUNT_2; i++) {
    fseek(fh_tibia, LOGIN_HOSTS_OFFSET_2+i*LOGIN_HOSTS_SIZE_2, SEEK_SET);
    if (ot_login_host) {
      fwrite(ot_login_ip, sizeof(char), strlen(ot_login_ip)+1, fh_tibia);
    } else {
      fprintf(fh_tibia, "tibia0%d.cipsoft.com", 
#ifdef WIN32
	      5-1
#else
	      i+1
#endif
	      );
    }
  }
  //close handle to executable
  if (fclose(fh_tibia) != 0) return 1;
  return 0;
}
