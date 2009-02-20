program Mapreader;

uses crt;

type
level = record
description : string[100];
items : array[1..4] of boolean;
mobs : array[1..4] of shortint;
walk : array[1..6] of word;
end;

const
loopend = 10;

var
map : array[1..loopend] of level;
mapfile : file of level;
req, tempno : byte;
mapname : string[20];
n, count : word;
tempchar : char;

procedure addmap;
begin
clrscr;
write(' What was your map called : ');
readln(mapname);
n := 0;
assign(mapfile, +mapname+'.ame');
reset(mapfile);
repeat
inc(n);
read(mapfile, map[n]);
until n = loopend;
write(' Which square would you like to look at (1/',loopend,') : ');
readln(n);
clrscr;
textcolor(random(6)+9);
writeln(' ',map[n].description);
req :=0;
repeat
inc(req);
if map[n].items[req] = true then writeln(' Y')
                            else writeln(' N');

until req = 4;

writeln(' These are the adjacent squares to the current square');
writeln(' North : ',map[n].walk[1]);
writeln(' South : ',map[n].walk[2]);
writeln(' East : ',map[n].walk[3]);
writeln(' West : ',map[n].walk[4]);
writeln(' Up : ',map[n].walk[5]);
writeln(' Down : ',map[n].walk[6]);

close(mapfile);
readkey;
end;

procedure editmap;
begin
clrscr;
readkey;
end;

begin
clrscr;
randomize;
textcolor(random(6)+9);
repeat
writeln('1. Read a map');
writeln('2. Edit an old map');
writeln('3. Quit');
write(' Please Choose an option from the menu above : ');
readln(req);
until req in[1,2,3];

if req = 1 then
begin
addmap;
end;

if req = 2 then
begin
editmap;
end;

if req = 3 then exit;

end.