PROGRAM funnyThingie;

USES
    Crt,Graph;

CONST
     WALKING = 1;
     IDLE = 0;
     ERASE = 2;
     DRAW = 0;

VAR
   grDriver,grMode:integer;

PROCEDURE StartGraph;
          BEGIN
               grDriver:=Detect;
               InitGraph(grDriver,grMode,'D:\TP\BGI');
          END;

PROCEDURE drawMan(X,Y,state:integer);
          BEGIN
               setcolor(15);
               circle(X-16,Y-48,16);
               setfillstyle(1,15);
               floodfill(X-16,Y-48,15);
               rectangle(X,Y
          END;

BEGIN {MAIN PROGRAM}
      StartGraph;
      delay(1000);
      drawMan(320,240,IDLE);
      REPEAT UNTIL keyPressed;
      CloseGraph;
END.