/*
 * Linux Tibia Loader
 * by Primer
 * 
 * Version 0.1b
 *
 * Modified for Tibia 8.0
 * by Talaturen
 *
 * LICENSE: GPL
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software Foundation,
 * 18 // Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
 *
 */

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <sys/ptrace.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>
#include <asm/ptrace.h>
#include <errno.h>
#include <elf.h>

#define HOST_MAX_SIZE 0x40
#define HOST_TO_PORT_SEP 0x64

/*
TODO:
- Find a way to not patch the executable.
*/

const char* tibia_server[10] = {"tibia01.cipsoft.com", "tibia02.cipsoft.com", "tibia03.cipsoft.com", "tibia04.cipsoft.com", "tibia05.cipsoft.com", "login01.tibia.com", "login02.tibia.com", "login03.tibia.com", "login04.tibia.com", "login05.tibia.com"};

const char otserv_rsakey[]=
"10912013296739942927886096050899"
"55415282375029027981291234687579"
"37266291492576446330739696001110"
"60390723088861007265581882535850"
"34290575928276294364131085660290"
"93628212635953836686562675849720"
"62078627943109021801768106152175"
"50567108238764764442605581471797"
"07119674283982419152118103759076"
"030616683978566631413";

const char tibia_rsakey[]=
"12471045942682794300437644989798"
"55821678017079606970371640449048"
"62948569380850421396904597686953"
"87702239460423942818549828416906"
"85818022776120810279667243363194"
"48537811441719076484340922854929"
"27351730866137072710538289911899"
"94038080458464446472844991231648"
"79035103627004668521005328367415"
"259939915284902061793";

long change_string(char *pmem, unsigned long size, const char *str_old, const char *str_new)
{
    unsigned long i,j;
    int len = strlen(str_old) + 1;
    for(i=0,j=0; j < len; i++)
    {
        if(i >= size)
            return -1;
        
        if(pmem[i] == str_old[j])
            j++;
        else
            j=0;
    }
    
    i -= j;
    len = strlen(str_new) + 1;
    for(j=0; j < len; j++, i++)
        pmem[i] = str_new[j];
        
    return (long)(i - j);
}

int main(int argc, char *argv[])
{
    char host[HOST_MAX_SIZE]="localhost";
    unsigned long port=7171;
    char path[256]="./Tibia";
    
    unsigned long ad_bss;
    unsigned long ad_bss_size;
    unsigned long ad_rodata;
    unsigned long ad_rodata_size;

    if(argc > 3) strcpy(path, argv[3]);
    if(argc > 2) port = atol(argv[2]);
    if(argc > 1) strcpy(host, argv[1]);

    int fd;
    fd = open(path, O_RDWR);
    if(-1 == fd) {
        fprintf(stderr, "Failed to open %s.\n", path);
        return 1;
    }
    
    Elf32_Ehdr eh;
    int n;
    n = read(fd, &eh, sizeof(Elf32_Ehdr));
    if(n != sizeof(Elf32_Ehdr))
    {
        fprintf(stderr, "Error reading Elf Header.\n");
        close(fd);
        return 1;
    }
    
    if(-1 == lseek(fd, eh.e_shoff + (eh.e_shstrndx * eh.e_shentsize), SEEK_SET)) {
        fprintf(stderr, "Error in lseek.\n");
        close(fd);
        return 1;
    }
    
    Elf32_Shdr sh;
    n = read(fd, &sh, sizeof(Elf32_Shdr));
    if(n != sizeof(Elf32_Shdr))
    {
        fprintf(stderr, "Error reading Elf Header(2).\n");
        close(fd);
        return 1;
    }
    
    if(-1 == lseek(fd, sh.sh_offset, SEEK_SET)) {
        fprintf(stderr, "Error in lseek(2).\n");
        close(fd);
        return 1;
    }
    
    char *strtab = (char*)malloc(sh.sh_size);
    if(strtab == NULL)
    {
        fprintf(stderr, "Error in malloc.\n");
        close(fd);
        return 1;
    }
    
    n = read(fd, strtab, sh.sh_size);
    if(n != sh.sh_size)
    {
        fprintf(stderr, "Error reading Elf Header(3).\n");
        close(fd);
        return 1;
    }
    
    int pos = 0;
    int pos_data = 0;
    int pos_rodata = 0;
    for(;;)
    {
        if(pos > sh.sh_size)
        {
            fprintf(stderr, "Error searching for sections in strtab.\n");
            close(fd);
            return 1;
        }
        if(!pos_data && strcmp(strtab + pos, ".bss") == 0)
            pos_data = pos;
        else if(!pos_rodata && strcmp(strtab + pos, ".rodata") == 0)
            pos_rodata = pos;
        else if(pos_data && pos_rodata)
            break;
        
        pos += strlen(strtab + pos) + 1;
    }
    free(strtab);
    
    int i;
    int step = 0;
    for(i=0; step < 2; i++)
    {
        if(i >= eh.e_shnum)
        {
            fprintf(stderr, "Error searching for data sections in section header.\n");
            close(fd);
            return 1;
        }
        
        if(-1 == lseek(fd, eh.e_shoff + (i * eh.e_shentsize), SEEK_SET)) {
            fprintf(stderr, "Error in lseek(3).\n");
            close(fd);
            return 1;
        }
        
        n = read(fd, &sh, sizeof(Elf32_Shdr));
        if(n != sizeof(Elf32_Shdr))
        {
            fprintf(stderr, "Error reading Elf Header(4).\n");
            close(fd);
            return 1;
        }
        
        if(sh.sh_name == pos_data)
        {
            ad_bss = sh.sh_addr;
            ad_bss_size = sh.sh_size;
            step++;
        }
        else if(sh.sh_name == pos_rodata)
        {
            ad_rodata = sh.sh_addr;
            ad_rodata_size = sh.sh_size;
            
            // patching to make the section writeable
            sh.sh_flags = sh.sh_flags | SHF_WRITE;
            if(-1 == lseek(fd, eh.e_shoff + (i * eh.e_shentsize), SEEK_SET)) {
                fprintf(stderr, "Error in lseek(4).\n");
                close(fd);
                return 1;
            }
            n = write(fd, &sh, sizeof(Elf32_Shdr));
            if(n != sizeof(Elf32_Shdr))
            {
                fprintf(stderr, "Error writing Elf Header.\n");
                close(fd);
                return 1;
            }
            
            step++;
        }
    }
    
    close(fd);
    
    
    int pid;
    int wait_val;
    switch (pid = fork()) {
        case -1:
            perror("fork");
            break;
        case 0:
            if(-1 == ptrace(PTRACE_TRACEME, 0, NULL, NULL) && errno) {
                perror("ptrace(1)");
                return 1;
            }
            if(-1 == execl(path, path, NULL)) {
                perror("execl");
                return 1;
            }
            break;
        default:
            if(-1 == wait(&wait_val)) {
                perror("wait(1)");
                return 1;
            }
            
            int i,j;
            int counter=0;
            while (!WIFEXITED(wait_val)) {
                counter++;
                if(counter == 2) {
                    // change rsa key
                    char *pmem;
                    unsigned long data;
                    long pos;
                    
                    pmem = (char*)malloc(ad_rodata_size+sizeof(unsigned long));
                    
                    for(i=0; i<ad_rodata_size; i+=sizeof(unsigned long))
                    {
                        data = ptrace(PTRACE_PEEKDATA, pid, ad_rodata + i, NULL);
                        if(-1 == data && errno) {
                            perror("ptrace(2)");
                            return 1;
                        }
                        *((unsigned long *)(pmem + i)) = data;
                    }
                    
                    pos = change_string(pmem, ad_rodata_size, tibia_rsakey, otserv_rsakey);
                    if(-1 == pos)
                    {
                        fprintf(stderr, "RSA Key not found.\n");
                        return 1;
                    }
                    
                    for(i=0; i<strlen(otserv_rsakey); i+=sizeof(unsigned long))
                    {
                        if(-1 == ptrace(PTRACE_POKEDATA, pid, ad_rodata + pos + i, *((unsigned long *)(pmem + pos + i))) && errno) {
                            perror("ptrace(3)");
                            return 1;
                        }
                    }
                    
                    free(pmem);

                    // change host
            int i_;
            for(i_ = 0; i_<10; i_++)
            {
                        pmem = (char*)malloc(ad_bss_size+sizeof(unsigned long));
                        for(i=0; i<ad_bss_size; i+=sizeof(unsigned long))
                        {
                            data = ptrace(PTRACE_PEEKDATA, pid, ad_bss + i, NULL);
                                if(-1 == data && errno) {
                                    perror("ptrace(4)");
                                    return 1;
                                }
                                *((unsigned long *)(pmem + i)) = data;
                        }

                            pos = change_string(pmem, ad_bss_size, tibia_server[i_], host);
                            if(-1 == pos)
                           {
                               fprintf(stderr, "Test server host not found.\n");
                    return 1;
                            }

                        for(i=0; i<strlen(host); i+=sizeof(unsigned long))
                        {
                            if(-1 == ptrace(PTRACE_POKEDATA, pid, ad_bss + pos + i, *((unsigned long *)(pmem + pos + i))) && errno){
                                        perror("ptrace(5)");
                                       return 1;
                                   }
                        }
                        free(pmem);
            }
                    
                    // change port
                    data = ptrace(PTRACE_PEEKDATA, pid, ad_bss + pos + HOST_TO_PORT_SEP, NULL);
                    if(-1 == data && errno) {
                        perror("ptrace(6)");
                        return 1;
                    }
                    data >>= 16;
                    data <<= 16;
                    data += (port & 0xFFFF);
                    if(-1 == ptrace(PTRACE_POKEDATA, pid, ad_bss + pos + HOST_TO_PORT_SEP, data) && errno) {
                        perror("ptrace(7)");
                        return 1;
                    }

                    if(-1 == kill(pid, SIGALRM)) {
                        perror("kill SIGALRM");
                        return 1;
                    }
                    if(-1 == ptrace(PTRACE_DETACH, pid, NULL, NULL) && errno) {
                        perror("ptrace(5)");
                        return 1;
                    }
                    return 0;
                }
                
                if(-1 == ptrace(PTRACE_CONT, pid, NULL, NULL) && errno) {
                    perror("ptrace(6)");
                    return 1;
                }
                if(-1 == wait(&wait_val)) {
                    perror("wait(2)");
                    return 1;
                }
            }
    }
    return 0;
}
