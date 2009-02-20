5 CLS
CLEAR
PRINT
PRINT "What do wish to convert?"
PRINT "Miles to Kilometres Press 1"
PRINT "Inches to Centimetres Press 2"
PRINT "I'd like to goto the toilet Press 3"
INPUT "1, 2 or 3 (If your dying to go):"; x
SELECT CASE x
CASE 1
GOTO 10
CASE 2
GOTO 20
CASE 3
GOTO 100
CASE ELSE
END SELECT
CLS
PRINT "Do as you were told DUM ARSE! Or I'll ..."
FOR t = 1 TO 10000
NEXT t
GOTO 5
10 CLS
INPUT "Type in the number of miles you wish to convert to kilometres:"; M
K = M * 1.609344
PRINT "This is"; K; "kilometres"
FOR t = 1 TO 10000
NEXT t
GOTO 5
20 CLS
INPUT "Type in the number of inches you wish to convert to centimetres:"; i
c = i * 2.54
PRINT "This is"; c; "centimetres"
FOR t = 1 TO 10000
NEXT t
GOTO 5
100 CLS
PRINT "Have FUN! For a cool surprise, flush the loo before you rise!"
END








