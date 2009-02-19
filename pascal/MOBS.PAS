program mob_creator;
uses crt, dos;

Type

  Mob = record
  mtype, mname:string[20];
  str, dex, hp, arm, int :integer;
  levelc, mana :integer;
end;


Var
  ifmobyn, statgood : char;
  name : string[20];
  code : string;
  z : file of Mob;
  c : Mob;
  count : shortint;
  pre :string;

Procedure message_window;

begin
     Textbackground(black);
     Textcolor(white);
     Window(3,3,78,24);
     clrscr;
end;

Procedure menu_window;

begin
     textbackground(blue);
     textcolor(11+128);
     window(0,3,79,24);
     clrscr;
end;

procedure finish;
begin
  clrscr;
  writeln('Mob file created. c:\tp\turbo\amenc\mobs\',c.mname,'.mlf');
  readln;
end;

procedure creating;
begin
   repeat
  clrscr;
  writeln('This is what you mob looks like right now.');
  writeln(c.mname);
  writeln('Type : ',c.mtype);
  writeln('        Strength [',c.str,']');
  writeln('        Dexterity [',c.dex,']');
  writeln('        Armour [',c.arm,']');
  writeln('        Intelligance [',c.int,']');
  writeln('        Health [',c.hp,']');
  writeln('        Mana [',c.mana,']');
  writeln('        Level [',c.levelc,']');
  writeln;
  write('Do you want this mob stored? ');
  readln(ifmobyn);
   until ifmobyn in ['y','n','Y','N'];
    ifmobyn:=upcase(ifmobyn);
  if ifmobyn = 'Y' then
begin
  assign(z, 'c:\tp\turbo\amenc\mobs\'+c.mname+'.mlf');
  rewrite(z);
  write(z, c);
  close(z);
end

  else Halt(0);
end;

procedure mob_type;
begin
  repeat
 clrscr;
 textcolor(white);
 writeln('What do you want the type of the mob to be : ');
 textcolor(red);
 writeln('                                             (a) Fire');
 textcolor(blue);
 writeln('                                             (b) Cold');
 textcolor(10);
 writeln('                                             (c) Poison');
 textcolor(yellow);
 writeln('                                             (d) Lightning');
 textcolor(brown);
 writeln('                                             (e) Earth');
 textcolor(lightgray);
 writeln('                                             (f) Evil');
 textcolor(white);
 writeln('                                             (g) None');
 writeln;
 textcolor(white);
 writeln('Type the letter of your choice.');
 readln(ifmobyn);
  until ifmobyn in ['a','b','c','d','e','f','g','A','B','C','D','E','F','G'];
   ifmobyn:=upcase(ifmobyn);
 if ifmobyn = 'A' then
begin
  c.mtype:='Fire';
end

  else

 if ifmobyn = 'B' then
begin
  c.mtype:='Cold';
end

  else

 if ifmobyn = 'C' then
begin
  c.mtype:='Poison';
end

  else

 if ifmobyn = 'D' then
begin
  c.mtype:='Lightning';
end

  else

 if ifmobyn = 'E' then
begin
  c.mtype:='Earth';
end

  else

 if ifmobyn = 'F' then
begin
  c.mtype:='Evil';
end

  else

 if ifmobyn = 'G' then
begin
  c.mtype:='None';
end;
   repeat
  write('Do you want your mob to be a ',c.mtype,' type : ');
  readln(ifmobyn);
   until ifmobyn in ['Y','N','y','n'];
  ifmobyn:=upcase(ifmobyn);
    if ifmobyn = 'N' then
 begin
  mob_type;
 end;
end;

procedure show_mob;
begin
  clrscr;
  write('So the mob shall be : ');
   if c.str > 30 then
begin                     
 write('Very strong!                       ');
end

  else

   if c.str > 20 then
begin
 writeln('Moderatly strong. ');
end

  else

   if c.str > 10 then
begin
 writeln('Not very strong.  ');
end

  else

   if c.str < 11 then
begin
 writeln('Not strong at all.');
end;

   if c.dex > 30 then
begin
 writeln('                      Extreamly manoverable!');
end

  else

   if c.dex > 20 then
begin
 writeln('                      Good agility.');
end

  else

   if c.dex > 10 then
begin
 writeln('                      Slightly quick.');
end

  else

   if c.dex < 11 then
begin
 writeln('                      Very slow.');
end;

   if c.arm > 20 then
begin
 writeln('                      Extreamly tuff skin!');
end

  else

   if c.arm > 10 then
begin
 writeln('                      Can take hits.');
end

  else

   if c.arm < 11 then
begin
 writeln('                      Thin armour.');
end;

   if c.int > 20 then
begin
 writeln('                      Can be a brain sergion!');
end

  else

   if c.int > 10 then
begin
 writeln('                      Got some brains.');
end

  else

   if c.int < 11 then
begin
 writeln('                      Not too bright.');
end;

   if c.hp > 300 then
begin
 writeln('                      This mumma can take hit ups!');
end

  else

   if c.hp > 200 then
begin
 writeln('                      Can take a fare few hits.');
end

  else

   if c.hp > 100 then
begin
 writeln('                      Not too much life.');
end

  else

   if c.hp < 101 then
begin
 writeln('                      Pussy.');
end;

   if c.mana > 80 then
begin
 writeln('                      Spell mainia!');
end

  else

   if c.mana > 40 then
begin
 writeln('                      He`s guna have some fun.');
end

  else

   if c.mana < 41 then
begin
 writeln('                      This guy dosn`t know magic.');
end;
 repeat
write('Are you sure this is what you want (If you type `n` the program will stop) : ');
readln(ifmobyn);
 until ifmobyn in ['y','n','Y','N'];
  ifmobyn:=upcase(ifmobyn);
 if ifmobyn = 'Y' then
begin
 mob_type;
end

  else halt(0)
end;

procedure stats;
begin
  clrscr;
  textcolor(14);
  writeln('Applying ',c.mname,' stats...');
  writeln;
  textcolor(13);
  write('What is the strength of the mob : ');
  readln(c.str);
  write('What is the dexterity of the mob : ');
  readln(c.dex);
  write('What is the armour of the mob : ');
  readln(c.arm);
  write('What is the intelligance of the mob : ');
  readln(c.int);
  write('What is the health of the mob : ');
  readln(c.hp);
  write('What is the mana of the mob : ');
  readln(c.mana);
  write('What is the level of the mob : ');
  readln(c.levelc);
   repeat
  clrscr;
  write('Are you sure that the strength should be [',c.str,'] ');
  readln(statgood);
   until statgood in ['y','n','Y','N'];
    statgood:=upcase(statgood);
 if statgood = 'N' then
begin
  write('What is the strength of the mob : ');
  readln(c.str);
end;
   repeat
  write('Are you sure that the dexterity should be [',c.dex,'] ');
  readln(statgood);
   until statgood in ['y','n','Y','N'];
    statgood:=upcase(statgood);
 if statgood = 'N' then
begin
  write('What is the dexterity of the mob : ');
  readln(c.dex);
end;
   repeat
  write('Are you sure that the armour should be [',c.arm,'] ');
  readln(statgood);
   until statgood in ['y','n','Y','N'];
    statgood:=upcase(statgood);
 if statgood = 'N' then
begin
  write('What is the armour of the mob : ');
  readln(c.arm);
end;
   repeat
  write('Are you sure that the intelligance should be [',c.int,'] ');
  readln(statgood);
   until statgood in ['y','n','Y','N'];
    statgood:=upcase(statgood);
 if statgood = 'N' then
begin
  write('What is the intelligance of the mob : ');
  readln(c.int);
end;
   repeat
  write('Are you sure that the health should be [',c.hp,'] ');
  readln(statgood);
   until statgood in ['y','n','Y','N'];
    statgood:=upcase(statgood);
 if statgood = 'N' then
begin
  write('What is the health of the mob : ');
  readln(c.hp);
end;
   repeat
  write('Are you sure that the mana should be [',c.mana,'] ');
  readln(statgood);
   until statgood in ['y','n','Y','N'];
    statgood:=upcase(statgood);
 if statgood = 'N' then
begin
  write('What is the mana of the mob : ');
  readln(c.mana);
end;
   repeat
  write('Are you sure that the level should be [',c.levelc,'] ');
  readln(statgood);
   until statgood in ['y','n','Y','N'];
    statgood:=upcase(statgood);
 if statgood = 'N' then
begin
  write('What is the level of the mob : ');
  readln(c.levelc);
end;
end;

procedure make_new;
begin
   repeat
  clrscr;
  write('What will be the mobs name : ');
  readln(c.mname);
   until c.mname > '';
   repeat
 clrscr;
  write(c.mname,' will be the name? ');
  readln(ifmobyn);
   until ifmobyn in ['y','n','Y','N'];
    ifmobyn:=upcase(ifmobyn);
 if ifmobyn = 'Y' then
begin
  stats;
end

  else

 if ifmobyn = 'N' then
begin
  make_new;
end;
end;

procedure new;
begin
   repeat
  clrscr;
  writeln('Are you sure that you want to use this program.');
  readln(ifmobyn);
   until ifmobyn in ['y','n','Y','N'];
    ifmobyn := upcase(ifmobyn);
 if ifmobyn = 'Y' then
begin
  make_new;
end
   else Halt(0);
end;

procedure previous_conv;
begin
   repeat
  textcolor(white);
  clrscr;
  writeln('Type QUIT to exit.');
  writeln('Type SAVE to save all conversions.');
  writeln;
  writeln('This is what you mob looks like right now.');
  writeln(c.mname);
  writeln('Type : ',c.mtype);
  writeln('        Strength [',c.str,']');
  writeln('        Dexterity [',c.dex,']');
  writeln('        Armour [',c.arm,']');
  writeln('        Intelligance [',c.int,']');
  writeln('        Health [',c.hp,']');
  writeln('        Mana [',c.mana,']');
  writeln('        Level [',c.levelc,']');
  writeln;
  write('What do you want converted? ');
  readln(pre);
  for count:=1 to length(pre) do
    pre[count]:=upcase(pre[count]);

    if (pre = 'STRENGTH') or (pre = 'STRENGT') or
    (pre = 'STRENG') or (pre = 'STREN') or
    (pre = 'STRE') or (pre = 'STR') or
    (pre = 'ST') then
begin
  write('What do you want the strength to be? ');
  readln(c.str);
end

  else

    if (pre = 'DEXTERITY') or (pre = 'DEXTERIT') or
    (pre = 'DEXTERI') or (pre = 'DEXTER') or
    (pre = 'DEXTE') or (pre = 'DEXT') or
    (pre = 'DEX') or (pre = 'DE') then
begin
  write('What do you want the dextreity to be? ');
  readln(c.dex);
end

  else

    if (pre = 'ARMOUR') or (pre = 'ARMOU') or
    (pre = 'ARMO') or (pre = 'ARM') or
    (pre = 'AR') then
begin
  write('What do you want the armour to be? ');
  readln(c.arm);
end

  else

    if (pre = 'INTELLIGANCE') or (pre = 'INTELLIGANC') or
    (pre = 'INTELLIGAN') or (pre = 'INTELLIGA') or
    (pre = 'INTELLIG') or (pre = 'INTELLI') or
    (pre = 'INTELL') or (pre = 'INTEL') or
    (pre = 'INTE') or (pre = 'INT') or
    (pre = 'IN') then
begin
  write('What do you want the intelligance to be? ');
  readln(c.int);
end

  else

    if (pre = 'HEALTH') or (pre = 'HEALT') or
    (pre = 'HEAL') or (pre = 'HEA') or
    (pre = 'HE') then
begin
  write('What do you want the Health to be? ');
  readln(c.hp);
end

  else

    if (pre = 'MANA') or (pre = 'MAN') or
    (pre = 'MA') then
begin
  write('What do you want the Mana to be? ');
  readln(c.mana);
end

  else

    if (pre = 'LEVEL') or (pre = 'LEVE') or
    (pre = 'LEV') or (pre = 'LE') then
begin
  write('What do you want the Level to be? ');
  readln(c.Levelc);
end

  else

    if (pre = 'SAVE') or (pre = 'SAV') or
    (pre = 'SA') then
begin
  writeln('Saving stats...');
  assign(z, 'C:\tp\turbo\amenc\mobs\'+c.mname+'.mlf');
  reset(z);
  write(z, c);
  close(z);
  writeln('Save complete!');
  readln;
end

     Until (pre = 'QUIT') or (pre = 'QUI') or
    (pre = 'QU') or (pre = 'Q');

     If (pre = 'QUIT') or (pre = 'QUI') or
    (pre = 'QU') or (pre = 'Q') then
 begin
 textcolor(11+128);
   write('Sure you want to quit (Y/N) : ');
   readln(ifmobyn);
   ifmobyn:= UPCASE(ifmobyn);
 end;
    If ifmobyn = 'N' then
 begin
   previous_conv;
 end

   else halt(0)

end;

procedure previous;
begin
   repeat
  clrscr;
  write('Have got a previous mob file that you want convert : ');
  readln(ifmobyn);
   until ifmobyn in ['y','n','Y','N'];
  ifmobyn:=upcase(ifmobyn);
 if ifmobyn = 'Y' then
begin
  Write('What is the name of the mob? ');
  readln(name);

  assign(z, 'C:\tp\turbo\amenc\mobs\'+name+'.mlf');
  reset(z);
  read(z, c);
  close(z);

  previous_conv;
end;
end;

procedure start;
begin
  menu_window;
  clrscr;
  writeln;
  writeln('                              Mobber v1.1 Beta');
  message_window;
  clrscr;
  writeln('Mob creator v1.1 Beta was created by AchromiciA & Crizmal.');
  writeln('This program is only to be used by the original creators.');
  readln;
 repeat
  clrscr;
  write('Type in security code : ');

  readln(code);
 until code > '';
    if code = '56gifcode' then
 begin
   previous;
 end
     else halt(0);

end;

begin
  start;
  new;
  show_mob;
  creating;
  finish;
end.