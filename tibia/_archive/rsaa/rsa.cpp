/*
    OpenTibia Client
    GNU PUBLIC LICENSE

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
*/

#include "rsa.h"

int ___gmpn_bases = 0;

RSA* RSA::instance = NULL;

RSA* RSA::getInstance()
{
	if(!instance){
		instance = new RSA;
	}
	return instance;
}

RSA::RSA()
{	
	mpz_init2(m_mod, 1024); 	
    mpz_init2(m_e, 32); 	
}

RSA::~RSA()
{
   mpz_clear(m_mod); 	
   mpz_clear(m_e);
}

void RSA::SetKey(char* mod)
{		
    mpz_set_ui(m_e, 65537); 
    mpz_set_str(m_mod, mod, 10);
}


void RSA::encrypt(char *msg)
{	
   mpz_init2(m, 1024); 	
   mpz_init2(c, 1024); 	

   mpz_import(m, 128, 1, 1, 0, 0, msg); 	
		
   mpz_powm(c, m, m_e, m_mod); 	
			
   size_t count = (mpz_sizeinbase(c, 2) + 7)/8; 	
   memset(msg, 0, 128 - count); 	
   mpz_export(&msg[128 - count], NULL, 1, 1, 0, 0, c); 	
		
   mpz_clear(m); 	
   mpz_clear(c);
}
