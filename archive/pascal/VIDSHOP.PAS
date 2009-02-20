Program videoshop;

uses crt;

type
Video = record
Name : string[25];
Loc : integer;
Stars : Array[1..3] of string[15];
end;

var
vid : video;
vidfile : file of video;
request, count : byte;


procedure findvid;
begin

end;

procedure addvid;
begin

end;

Procedure delvid;
begin

end;

Procedure Quit;
begin
exit;
end;

procedure Get_selection;

begin
clrscr;
textcolor(random(6)+9);
writeln('1. Find a Video');
writeln('2. Add a video');
writeln('3. Delete a video');
writeln('4. Quit');
write('Please enter your selection : ');
readln(request);

case request of
1 : findvid;
2 : addvid;
3 : delvid;
4 : Quit;
end;
end;


Procedure in_window;

begin
Textbackground(black);
Textcolor(white);
Window(3,3,78,24);
clrscr;
end;

Procedure out_window;

begin
textbackground(blue);
textcolor(11+128);
window(0,3,79,24);
clrscr;
writeln;
writeln('       Created by Crizmal                    Videoshop V1.1 Alpha');
end;


begin
randomize;
out_window;
in_window;
get_selection;
end.


