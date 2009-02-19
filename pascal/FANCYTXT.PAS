UNIT fancyTxt;

INTERFACE

USES
    crt;

CONST
     {JUSTIFICATIONS}
     JUSTIFY_LEFT = 1;
     JUSTIFY_RIGHT = 2;
     JUSTIFY_CENTER = 3;
     {UNDERLINE STYLES}
     UNDERLINE_NONE = 1;
     UNDERLINE_ONE = 2;
     UNDERLINE_TWO = 3;

PROCEDURE writeLnJMC(msg:string;justification,underlinestyle:integer);

IMPLEMENTATION

PROCEDURE writeLnJMC(msg:string;justification,underlinestyle:integer);
          VAR
             a,x,y,z:integer;
             b:string;
          BEGIN
               x := length(msg);
               y := (80 - x) DIV 2;
               z := (80 - x);
               CASE justification OF
                    JUSTIFY_CENTER:gotoxy(y,whereY);
                    JUSTIFY_LEFT:gotoxy(1,whereY);
                    JUSTIFY_RIGHT:gotoxy(z,whereY);
               END;
               writeln(msg);
               CASE underlinestyle OF
                    UNDERLINE_ONE:b := '-';
                    UNDERLINE_TWO:b := '=';
               END;

               IF NOT(underlinestyle = UNDERLINE_NONE)
                  THEN BEGIN
                            CASE justification OF
                                 JUSTIFY_CENTER:gotoxy(y,whereY);
                                 JUSTIFY_LEFT:gotoxy(1,whereY);
                                 JUSTIFY_RIGHT:gotoxy(z,whereY);
                            END;
                            FOR a := 1 TO x DO write(b);
                            writeln;
                       END;
          END;
END.