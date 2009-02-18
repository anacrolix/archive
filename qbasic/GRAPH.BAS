1 CLEAR : CLS
2 g: PRINT "Graph Battle"
5 CLS : o = 12: p = 12: y = 2: z = 2: m = 1: n = 1
10 INPUT "player 1 Move or Fire?  "; g$
20 IF g$ = "f" THEN GOSUB p1
30 PRINT "Player 1 Type your new coordinates"
35 INPUT "Enter Horizontal Value  "; a:
   INPUT "Enter Vertical Value  "; b
36 IF (a > m + y) + (b > n + y) + (a < m - y) + (b < n - y) THEN 30
40 m = a: n = b
IF (m <= o) + (n <= o) THEN 30
50 PRINT "Player 1 Position":
PRINT "Horizontal"; m; "Vertical"; n
60 INPUT "Player 2 Move or Fire?  "; h$
70 IF h$ = "f" THEN GOSUB p2
80 PRINT "Player 2 Type your new coordinates"
81 INPUT "Enter Horizontal Value  "; c:
   INPUT "Enter Vertical Value  "; d
85 IF (c <= o) + (d <= o) THEN 80
86 IF (c <= o) + (d <= o) + c < o - z + (d < p - z) THEN 80
90 PRINT "Player 2 Position":
PRINT "Horizontal"; o; "Vertical"; p
100 GOTO 100
110 p1: INPUT "Fire to (Horizontal)"; i: INPUT "Fire to (Vertical)"; j
120 INPUT "Angle"; e
130 r = (15 * cose) * ((15 * sine) / 32.2)










