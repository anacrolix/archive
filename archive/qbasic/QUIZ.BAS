CLS
5 CLEAR
INPUT "Are you new"; new$
SELECT CASE n$
CASE "y", "yes", "true", "1"
GOTO 10
CASE "n", "no", "0", "false"
GOTO 20
CASE ELSE
PRINT "Incorrect input, retry."
GOTO 5
END SELECT
10 INPUT "Please enter your name"; name$
INPUT "Your age"; age$
INPUT "Your favorite hobbies"; hobby$







20

