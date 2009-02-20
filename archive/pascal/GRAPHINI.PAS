PROGRAM GraphInit;

USES
    Crt,Graph;

VAR
   grDriver,grMode:integer;

PROCEDURE StartGraph;
          BEGIN
               grDriver:=Detect;
               InitGraph(grDriver,grMode,'C:\TP\BGI');
          END;

BEGIN {MAIN PROGRAM}
      StartGraph;

      CloseGraph;
END.