Program IttyBit;

uses crt, dos;

var
   XPos : Integer;
   YPos : Integer;
   i : Integer;
   Key : Char;

Function Roll(i:Integer):Integer;
begin
Roll:=Random(i)+1;
end;

Procedure SplashScreen;
begin

repeat
     repeat
     ClrScr;
     textcolor(yellow);
     GotoXY(31,13);
     write('Welcome to ');
     textcolor(Roll(15)); write('I');
     textcolor(Roll(15)); write('t');
     textcolor(Roll(15)); write('t');
     textcolor(Roll(15)); write('y ');
     textcolor(Roll(15)); write('B');
     textcolor(Roll(15)); write('i');
     textcolor(Roll(15)); write('t');
     textcolor(white);
     GotoXY(1,25);
     write('v. 0.01');
     sound(Roll(1800)+200);
     delay(75);
     NoSound;
     sound(Roll(1800)+200);
     delay(75);
     NoSound;
     sound(Roll(1800)+200);
     delay(75);
     NoSound;
     until KeyPressed;

until KeyPressed;

end;

Procedure Movement;
begin

repeat
      Key:=ReadKey;
      Key:=UpCase(Key);
until Key in ['4','8','6','2','Q'];

Case Key of
     '4' : begin
         XPos:=XPos-1;
         If XPos = 0 then
         XPos:=80;
         end;
     '8' : begin
         YPos:=YPos-1;
         If YPos=0 then
         YPos:=24;
         end;
     '6' : begin
         XPos:=XPos+1;
         If XPos = 80 then
         XPos:=1;
         end;
     '2' : begin
         YPos:=YPos+1;
         if YPos = 25 then
         YPos:=1;
         end;
end;

end;

Procedure DrawX;
begin
     ClrScr;
     textcolor(white);
     GotoXY(XPos,YPos);
     write('X');
end;

begin
ClrScr;

SplashScreen;

ClrScr;

XPos:=40;
YPos:=13;
GotoXY(XPos,YPos);
write('X');

repeat
      Movement;
      DrawX;
until Key in ['Q'];

end.
