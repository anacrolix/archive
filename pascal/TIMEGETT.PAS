program bil;

uses Dos,crt;

var
  time, time2:longint;
  h, m, s, hund : word;

begin
  clrscr;
  GetTime(h, m, s, hund);
  time:=(h*360);
  time:=time*10+(m*60)+(s);

  Writeln(time);
  readln;
end.