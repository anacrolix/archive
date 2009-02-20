/* Replace "dll.h" with the name of your header */
#include "dll.h"
#include "rsa.h"
#include <windows.h>

//Tibia client RSA public key
char tibia_rsa_key[] = "124710459426827943004376449897985582167801707960697037164044904862948569380850421396904597686953877022394604239428185498284169068581802277612081027966724336319448537811441719076484340922854929273517308661370727105382899118999403808045846444647284499123164879035103627004668521005328367415259939915284902061793";

extern "C" __declspec(dllexport) void __cdecl SetKey(char *rsakey)
{
//	DISABLED!
//	RSA *rsa = RSA::getInstance();
//	rsa->SetKey(rsakey);
//
}

extern "C" __declspec(dllexport) void __cdecl Encrypt(char *cData)
{
	RSA *rsa = RSA::getInstance();

	rsa->SetKey(tibia_rsa_key);
	rsa->encrypt(cData);
}

BOOL APIENTRY DllMain (HINSTANCE hInst     /* Library instance handle. */ ,
                       DWORD reason        /* Reason this function is being called. */ ,
                       LPVOID reserved     /* Not used. */ )
{

    /* Returns TRUE on success, FALSE on failure */
    return TRUE;
}
