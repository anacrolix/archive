CLEAR
CLS
PRINT "You"
INPUT "Tohit"; th
INPUT "MinDam"; mind
INPUT "MaxDam"; maxd
INPUT "AC"; ac
INPUT "Hit Points"; hp
PRINT "It"
INPUT "Enemy Tohit"; eth
INPUT "E, MinDam"; emind
INPUT "E, MaxDam"; emaxd
INPUT "E,AC"; eac
INPUT "E Hit points"; ehp
theac = th - eac
thac = eth - ac
in = RND * 5 + 1
ein = RND * 5 + 1
IF in > ein THEN 10
IF ein < in THEN 20
10 LET throll = RND * 20 + 1
IF throll >= theac THEN 12
GOTO 20
12 LET ehp = ehp - (RND * (maxd - mind) + 1)
IF ehp < 0 THEN 14 ELSE 20
14 PRINT "Enemy dies!"
END
20 LET throll = RND * 20 + 1
IF throll >= thac THEN 22 ELSE 10
22 LET hp = hp - (RND * (emaxd - emind) + 1)
IF hp < 0 THEN 24 ELSE 10
24 PRINT "You Lose"











