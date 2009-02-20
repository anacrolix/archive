DECLARE SUB combat (p!, s!, m!, e!)
CLS
CLEAR
p = 2
s = 4
RANDOMIZE TIMER

'GOBLIN ROOM
CLS
PRINT "You find yourself is a dark room"
PRINT "A goblin runs out and attacks!"
e = 1
m = 3

CALL combat

SUB combat (p, s, m, e)

'FIGHT OR RUN
PRINT "Fight or run(f or r)"
5 INPUT o$
SELECT CASE o$
CASE IS = "f"
GOTO 10
CASE IS = "r"
GOTO 20
CASE ELSE
GOTO 5
END SELECT

'FIGHT
10 PRINT "You will fight"
f = RND * (e + p)
IF f < p THEN 15 ELSE 16
15 PRINT "You win"
END
16 PRINT "You lose"
END

'ATTEMPT TO RUN
20 PRINT "You attempt to run"
SELECT CASE s
CASE IS > m
GOTO 30
CASE IS = m
GOTO 40
CASE IS < m
GOTO 50
END SELECT

'RUN AWAY SUCCESSFULLY
30 PRINT "You run away"
END

'HAVE TROUBLE RUNNING AWAY
40 r = RND
PRINT "You have trouble losing it but;"
IF r < .5 THEN PRINT "You make it away!" ELSE 50
GOTO 30

'CAN'T GET AWAY
50 PRINT "You don't make it!  You must fight!"
GOTO 10

END SUB

