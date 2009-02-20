PROGRAM GraphInit;

USES
    Crt,Graph;

VAR
   grDriver,grMode:integer;

PROCEDURE StartGraph;
          BEGIN
               grdriver:=1{detect;};
               grmode:=0;
               InitGraph(grDriver,grmode,'C:\TP\BGI');
          END;

PROCEDURE drawLoop;
          BEGIN

          END;

BEGIN {MAIN PROGRAM}
      StartGraph;

      CloseGraph;
      END.