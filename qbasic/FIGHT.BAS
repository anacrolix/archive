CLEAR
CLS
5 INPUT "Please press 1 to fight or 2 to customize     ?", a
IF a = 1 THEN 50
IF a = 2 THEN 10 ELSE GOTO 5
10 CLS
INPUT "1-12,(this will be your SKILL)     ?"; S
INPUT "1-12,(this will be your LUCK)     ?"; L
INPUT "1-24,(this will be your STAMINA)     ?"; H
INPUT "1-12,(this will be your ARMOUR)     ?"; Q
IF S > 12 OR L > 12 OR Q > 12 THEN 10
IF H > 24 THEN 10
GOTO 100
50 RANDOMIZE TIMER
S = INT(RND * 6) + 7
L = INT(RND * 6) + 7
H = INT(RND * 12) + 13
Q = INT(RND * 6) + 7
100 INPUT "Enemys SKILL     "; Z
INPUT "Enemys HEALTH    "; X
IF S >= Z THEN PLAY "<<<l3ggl5b->c<l3ggl5ff#g" ELSE PLAY "<<<l2c#d-g#cdef"
LOCATE 12, 40
P = 0
150 LET P = P + 1
COLOR 4
PRINT "Round"; P













