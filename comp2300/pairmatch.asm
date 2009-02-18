	.file	"e:\lcc\include\stdio.h"
_$M0:
	.file	"h:\my uni work\comp2300\pairmatch.c"
	.text
	.file	"h:\my uni work\comp2300\pairmatch.c"
_$M1:
	.text
;    1 /* ---------------------------------------------------------------------
;    2 
;    3              Name: Matthew Joiner
;    4    Student Number: 4125668
;    5            Course: COMP2300
;    6 Assignment Number: 2
;    7 Name of this file: pairmatch.c
;    8         Lab Group: 2
;    9 
;   10 
;   11 I declare that the material I am submitting in this file is entirely
;   12 my own work.  I have not collaborated with anyone to produce it, nor
;   13 have I copied it, in part or in full, from work produced by someone else.
;   14 
;   15    --------------------------------------------------------------------- */
;   16 
;   17 #include <stdio.h>
;   18    
;   19 #define SEQMAX 10   
;   20 
;   21 void readSeq(char *s, int len) {
	.type	_readSeq,function
_readSeq:
	pushl	%ebp
	movl	%esp,%ebp
	pushl	%ecx
	pushl	%eax
	pushl	%ebx
	pushl	%esi
	pushl	%edi
	.line	21
;   22   int i = 0;
	.line	22
	movl	$0,-8(%ebp)
;   23   char c = getchar();
	.line	23
	call	_getchar
	movl	%ax,%bx
	movb	%bl,-1(%ebp)
	jmp	_$3
_$2:
;   24   while (c != '\0' && c != '\n') {
;   25     if (i < len) s[i] = c;
	.line	25
	movl	12(%ebp),%edi
	cmpl	%edi,-8(%ebp)
	jge	_$5
	movl	-8(%ebp),%edi
	movl	8(%ebp),%esi
	movb	-1(%ebp),%bl
	movb	%bl,(%esi,%edi)
_$5:
;   26     i++;
	.line	26
	incl	-8(%ebp)
;   27     c = getchar();
	.line	27
	call	_getchar
	movl	%ax,%bx
	movb	%bl,-1(%ebp)
_$3:
	.line	24
	movsbl	-1(%ebp),%edi
	cmpl	$0,%edi
	je	_$7
	cmpl	$10,%edi
	jne	_$2
_$7:
;   28   }
;   29   if (i < len) s[i] = '\0';
	.line	29
	movl	12(%ebp),%edi
	cmpl	%edi,-8(%ebp)
	jge	_$1
	movl	-8(%ebp),%edi
	movl	8(%ebp),%esi
	movb	$0,(%esi,%edi)
;   30   return;
	.line	30
_$1:
;   31 }
	.line	31
	popl	%edi
	popl	%esi
	popl	%ebx
	leave
	ret
_$13:
	.size	_readSeq,_$13-_readSeq
	.globl	_readSeq
;   32 
;   33 int matchPairs(char *s1, char *s2, int len) {
	.type	_matchPairs,function
_matchPairs:
	pushl	%ebp
	movl	%esp,%ebp
	subl	$36,%esp
	pushl	%ebx
	pushl	%esi
	pushl	%edi
	.line	33
;   34   int i, j, matches = 0, usedPair[len];
	.line	34
	movl	$0,-28(%ebp)
	movl	16(%ebp),%edi
	sall	$2,%edi
	movl	%edi,-36(%ebp)
	pushl	-36(%ebp)
	call	__alloca
	addl	$4,%esp
	movl	%eax,-24(%ebp)
;   35   //clear usePair
;   36   for (i=0;i<len;i++) usedPair[i]=0;
	.line	36
	movl	$0,-8(%ebp)
	jmp	_$18
_$15:
	movl	-8(%ebp),%edi
	movl	-24(%ebp),%esi
	movl	$0,(%esi,%edi,4)
_$16:
	incl	-8(%ebp)
_$18:
	movl	16(%ebp),%edi
	cmpl	%edi,-8(%ebp)
	jl	_$15
;   37   for (i=0; i+1 < len && s1[i+1] != '\0'; i++) {
	.line	37
	movl	$0,-8(%ebp)
	jmp	_$22
_$19:
;   38     for (j=0; j+1 < len && s2[j+1] != '\0'; j++) {
	.line	38
	movl	$0,-4(%ebp)
	jmp	_$26
_$23:
;   39       //printf("\n%.2s,%.2s", &s1[i], &s2[j]);
;   40       if (usedPair[j] == 0 && s1[i] == s2[j] && s1[i+1] == s2[j+1]) {
	.line	40
	movl	-4(%ebp),%edi
	movl	-24(%ebp),%esi
	cmpl	$0,(%esi,%edi,4)
	jne	_$27
	movl	-8(%ebp),%esi
	movl	8(%ebp),%ebx
	movl	12(%ebp),%edx
	movsbl	(%ebx,%esi),%ecx
	movsbl	(%edx,%edi),%eax
	cmpl	%eax,%ecx
	jne	_$27
	movsbl	1(%esi,%ebx),%esi
	movsbl	1(%edi,%edx),%edi
	cmpl	%edi,%esi
	jne	_$27
;   41         matches++;
	.line	41
	incl	-28(%ebp)
;   42         //printf(" MATCH");
;   43         usedPair[j] = 1;
	.line	43
	movl	-4(%ebp),%edi
	movl	-24(%ebp),%esi
	movl	$1,(%esi,%edi,4)
;   44         break;
	.line	44
	jmp	_$25
_$27:
;   45       }
;   46     }
	.line	46
_$24:
	.line	38
	incl	-4(%ebp)
_$26:
	movl	-4(%ebp),%edi
	addl	$1,%edi
	cmpl	16(%ebp),%edi
	jge	_$29
	movl	12(%ebp),%esi
	cmpb	$0,(%esi,%edi)
	jne	_$23
_$29:
_$25:
;   47   }
	.line	47
_$20:
	.line	37
	incl	-8(%ebp)
_$22:
	movl	-8(%ebp),%edi
	addl	$1,%edi
	cmpl	16(%ebp),%edi
	jge	_$30
	movl	8(%ebp),%esi
	cmpb	$0,(%esi,%edi)
	jne	_$19
_$30:
;   48   //printf("\n");
;   49   /*printf("Matching pairs: ");
;   50   for (i=0;i+1<len && s2[i+1] != '\0';i++) if (usedPair[i]) printf("%.2s, ",&s2[i]);
;   51   printf("\n");*/
;   52   return matches;
	.line	52
	movl	-28(%ebp),%eax
_$14:
;   53 }
	.line	53
	leal	-48(%ebp),%esp
	popl	%edi
	popl	%esi
	popl	%ebx
	leave
	ret
_$38:
	.size	_matchPairs,_$38-_matchPairs
	.globl	_matchPairs
;   54 
;   55 int main(void) {
	.type	_main,function
_main:
	pushl	%ebp
	movl	%esp,%ebp
	subl	$20,%esp
	pushl	%edi
	.line	55
;   56   char firstLine[SEQMAX], secondLine[SEQMAX];
;   57   readSeq(firstLine, SEQMAX);
	.line	57
	pushl	$10
	leal	-10(%ebp),%edi
	pushl	%edi
	call	_readSeq
	addl	$8,%esp
;   58   readSeq(secondLine, SEQMAX);
	.line	58
	pushl	$10
	leal	-20(%ebp),%edi
	pushl	%edi
	call	_readSeq
	addl	$8,%esp
;   59   printf("%d\n", matchPairs(firstLine, secondLine, SEQMAX));
	.line	59
	pushl	$10
	leal	-20(%ebp),%edi
	pushl	%edi
	leal	-10(%ebp),%edi
	pushl	%edi
	call	_matchPairs
	addl	$12,%esp
	movl	%eax,%edi
	pushl	%edi
	pushl	$_$40
	call	_printf
	addl	$8,%esp
;   60   return 0;
	.line	60
	movl	$0,%eax
_$39:
;   61 }
	.line	61
	popl	%edi
	leave
	ret
_$42:
	.size	_main,_$42-_main
	.globl	_main
	.extern	_printf
	.extern	_getchar
	.extern	__alloca
	.data
_$40:
; "%d\n\x0"
	.byte	37,100,10,0
