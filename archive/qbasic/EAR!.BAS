10 CLS
15 DIM j(80)
20 CLEAR
30 LOCATE (12)
35 r = 6
37 c = 6
40 COLOR 4
50 PRINT TAB(40); "War!"
60 DO
70 LOOP UNTIL INKEY$ = " "
80 CLS
90 PRINT "Do you wish to play? Y/N"
100 INPUT "Y/N"; P$
105 IF P$ = "y" THEN 118 ELSE STOP
118 CLS
135 LOCATE 25, 1
136 INPUT A

 SELECT CASE A
 CASE IS = 8
 r = r - 1: GOTO 180
 CASE IS = 5
 r = r + 1: GOTO 180
 CASE IS = 4
 c = c - 1: GOTO 180
 CASE IS = 6
 c = c + 1: GOTO 180


180 END SELECT
 COLOR 2
 FOR c = 1 TO 50
 LOCATE (RND * 24), (RND * 79): PRINT "T"
 NEXT c
 LOCATE r, c
 PRINT "*"

360 GOTO 135
400 END













