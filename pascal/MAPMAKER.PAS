program Mapmaker;

uses crt;

type
level = record
description : string[250];
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
n, count, no : word;
tempchar : char;
preass : array[1..loopend*6] of boolean;


procedure addmap;
begin
     clrscr;
     write(' What would you like your map to be called : ');
     readln(mapname);
     n := 0;
     assign(mapfile, +mapname+'.ame');
     rewrite(mapfile);
     repeat
           clrscr;
           textcolor(random(6)+9);
           inc(n);
           writeln(' Enter a description (less than 250 characters) : ');
           readln(map[n].description);
           count := 0;
           writeln(' Select the item slots in which items are present (Y/N) : ');
           repeat
                 inc(count);
                 map[n].items[count] := false;
           until count = 4;
           count := 0;
           repeat
                 inc(count);
                 repeat
                       write(' Slot ',count,' : ');
                       readln(tempchar);
                       tempchar := upcase(tempchar);
                 until tempchar in['Y','N'];
                 if tempchar = 'Y' then map[n].items[count]:= true;
           until (tempchar = 'N') or (count = 4);

           count := 0;
           writeln(' Select the mob(s) present (If No more mobs in square, place a 0)');
           repeat
                 inc(count);
                 write(' Mob ',count,' : ');
                 readln(tempno);
                 while tempno <> 0 do
                       map[n].mobs[count] := tempno;
           until (tempno = 0) or (count = 6);


           writeln(' Select the adjacent squares to the current square (if none 0)');
           no := ((n-1)*6)+1;
           if preass[no] = true then writeln(' North : ',map[n].walk[1])
                                else
                                    begin
                                     write(' North : ');
                                     readln(map[n].walk[1]);
                                    end;
           count := n;
           repeat
                 inc(count);
                 if map[n].walk[1] = count then
                                               begin
                                                map[count].walk[2] := n;
                                                preass[((count-1)*6)+2] := true;
                                               end;
           until count = loopend+1;

           no := ((n-1)*6)+2;
           if preass[no] = true then writeln(' South : ',map[n].walk[2])
                                else
                                    begin
                                     write(' South : ');
                                     readln(map[n].walk[2]);
                                    end;
           count := n;
           repeat
                 inc(count);
                 if map[n].walk[2] = count then
                                               begin
                                                map[count].walk[1] := n;
                                                preass[((count-1)*6)+1] := true;
                                               end;
           until count = loopend+1;

           no := ((n-1)*6)+3;
           if preass[no] = true then writeln(' East : ',map[n].walk[3])
                                else
                                    begin
                                     write(' East : ');
                                     readln(map[n].walk[3]);
                                    end;
           count := n;
           repeat
                 inc(count);
                 if map[n].walk[3] = count then
                                               begin
                                                map[count].walk[4] := n;
                                                preass[((count-1)*6)+4] := true;
                                               end;
           until count = loopend+1;

           no := ((n-1)*6)+4;
           if preass[no] = true then writeln(' West : ',map[n].walk[4])
                                else
                                    begin
                                     write(' West : ');
                                     readln(map[n].walk[4]);
                                    end;
           count := n;
           repeat
                 inc(count);
                 if map[n].walk[4] = count then
                                               begin
                                                map[count].walk[3] := n;
                                                preass[((count-1)*6)+3] := true;
                                               end;
           until count = loopend+1;

           no := ((n-1)*6)+5;
           if preass[no] = true then writeln(' Up : ',map[n].walk[5])
                                else
                                    begin
                                     write(' Up : ');
                                     readln(map[n].walk[5]);
                                    end;
           count := n;
           repeat
                 inc(count);
                 if map[n].walk[5] = count then
                                               begin
                                                map[count].walk[6] := n;
                                                preass[((count-1)*6)+6] := true;
                                               end;
           until count = loopend+1;

           no := ((n-1)*6)+6;
           if preass[no] = true then writeln(' Down : ',map[n].walk[6])
                                else
                                    begin
                                     write(' Down : ');
                                     readln(map[n].walk[6]);
                                    end;
           count := n;
           repeat
                 inc(count);
                 if map[n].walk[6] = count then
                                               begin
                                                map[count].walk[5] := n;
                                                preass[((count-1)*6)+5] := true;
                                               end;
           until count = loopend+1;

           repeat
                 write('You sure this is the right information for this square (Y/N) : ');
                 readln(tempchar);
                 tempchar := upcase(tempchar);
           until tempchar in['Y','N'];

           if tempchar = 'N' then n := n - 1
                             else write(mapfile, map[n]);
until n = loopend;
close(mapfile);

end;

procedure editmap;
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
     repeat
           write(' Which square would you like to edit (1/',loopend,') : ');
           readln(n);
           repeat
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
           write(' Is this the square you would like to edit (Y/N) : ');
           readln(tempchar);
           tempchar := upcase(tempchar);
           until tempchar in['Y','N'];
           if tempchar = 'Y' then
           begin
           assign(mapfile, +mapname+'.ame');
           rewrite(mapfile);
           clrscr;
           textcolor(random(6)+9);
           inc(n);
           writeln(' Enter a description (less than 250 characters) : ');
           readln(map[n].description);
           count := 0;
                 writeln(' Select the item slots in which items are present (Y/N) : ');
           repeat
                 inc(count);
                 map[n].items[count] := false;
           until count = 4;
           count := 0;
           repeat
                 inc(count);
                 repeat
                       write(' Slot ',count,' : ');
                       readln(tempchar);
                       tempchar := upcase(tempchar);
                 until tempchar in['Y','N'];
                 if tempchar = 'Y' then map[n].items[count]:= true;
           until (tempchar = 'N') or (count = 4);

           count := 0;
           writeln(' Select the mob(s) present (If No more mobs in square, place a 0)');
           repeat
                 inc(count);
                 write(' Mob ',count,' : ');
                 readln(tempno);
                 while tempno <> 0 do
                       map[n].mobs[count] := tempno;
           until (tempno = 0) or (count = 6);


           writeln(' Select the adjacent squares to the current square (if none 0)');
           no := ((n-1)*6)+1;
           if preass[no] = true then writeln(' North : ',map[n].walk[1])
                                else
                                    begin
                                     write(' North : ');
                                     readln(map[n].walk[1]);
                                    end;
           count := n;
           repeat
                 inc(count);
                 if map[n].walk[1] = count then
                                               begin
                                                map[count].walk[2] := n;
                                                preass[((count-1)*6)+2] := true;
                                               end;
           until count = loopend+1;

           no := ((n-1)*6)+2;
           if preass[no] = true then writeln(' South : ',map[n].walk[2])
                                else
                                    begin
                                     write(' South : ');
                                     readln(map[n].walk[2]);
                                    end;
           count := n;
           repeat
                 inc(count);
                 if map[n].walk[2] = count then
                                               begin
                                                map[count].walk[1] := n;
                                                preass[((count-1)*6)+1] := true;
                                               end;
           until count = loopend+1;

           no := ((n-1)*6)+3;
           if preass[no] = true then writeln(' East : ',map[n].walk[3])
                                else
                                    begin
                                     write(' East : ');
                                     readln(map[n].walk[3]);
                                    end;
           count := n;
           repeat
                 inc(count);
                 if map[n].walk[3] = count then
                                               begin
                                                map[count].walk[4] := n;
                                                preass[((count-1)*6)+4] := true;
                                               end;
           until count = loopend+1;

           no := ((n-1)*6)+4;
           if preass[no] = true then writeln(' West : ',map[n].walk[4])
                                else
                                    begin
                                     write(' West : ');
                                     readln(map[n].walk[4]);
                                    end;
           count := n;
           repeat
                 inc(count);
                 if map[n].walk[4] = count then
                                               begin
                                                map[count].walk[3] := n;
                                                preass[((count-1)*6)+3] := true;
                                               end;
           until count = loopend+1;

           no := ((n-1)*6)+5;
           if preass[no] = true then writeln(' Up : ',map[n].walk[5])
                                else
                                    begin
                                     write(' Up : ');
                                     readln(map[n].walk[5]);
                                    end;
           count := n;
           repeat
                 inc(count);
                 if map[n].walk[5] = count then
                                               begin
                                                map[count].walk[6] := n;
                                                preass[((count-1)*6)+6] := true;
                                               end;
           until count = loopend+1;

           no := ((n-1)*6)+6;
           if preass[no] = true then writeln(' Down : ',map[n].walk[6])
                                else
                                    begin
                                     write(' Down : ');
                                     readln(map[n].walk[6]);
                                    end;
           count := n;
           repeat
                 inc(count);
                 if map[n].walk[6] = count then
                                               begin
                                                map[count].walk[5] := n;
                                                preass[((count-1)*6)+5] := true;
                                               end;
           until count = loopend+1;

           repeat
                 write('You sure this is the right information for this square (Y/N) : ');
                 readln(tempchar);
                 tempchar := upcase(tempchar);
           until tempchar in['Y','N'];

           if tempchar = 'N' then n := n - 1
                             else
                             begin
                             n:=0;
                             repeat
                             inc(count);
                             write(mapfile, map[n]);
                             until n = loopend;
                             end;
           close(mapfile);
           end;

     repeat
     clrscr;
     write(' Would you like to edit another square (Y/N) : ');
     readln(tempchar);
     tempchar := upcase(tempchar);
     until tempchar in['Y','N'];
     until tempchar = 'N';

     end;

begin
     for no := 1 to 30 do
         begin
          preass[no] := false;
         end;
     clrscr;
     randomize;
     textcolor(random(6)+9);
     repeat
           repeat
                 writeln('1. Create a new map');
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

     until 1 = 2;
end.