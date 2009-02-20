Program Weapon_creator;
uses crt;

type
  uniweapon = record
    uniweapname, uniweaptitle :string;
    umindam, umaxdam, uadur, umaxdur, unstr, undex, unlvl : integer;
    spec : array [1..12] of integer;
    uehp, uemana, uestr, uedex, ueint, uearm : integer;
    uM : boolean;
    uR : boolean;
    uhandtype : integer;
end;

  weapon = record
    weapname :string;
    mindam, maxdam, adur, maxdur, nstr, ndex, nlvl : integer;
    M : boolean;
    R : boolean;
    handtype : integer;
end;

var
  z : file of weapon;
  w : weapon;
  x : file of uniweapon;
  u : uniweapon;
  ifweapyn : char;
  secode, preweap : string;
  count:shortint;

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
     writeln;
     writeln('                         Weapon creator v1.0');
end;

Procedure ustatche;
begin
  clrscr;
  write('Minimum damage will be [',u.umindam,']');
  readln(ifweapyn);
  ifweapyn:=upcase(ifweapyn);
    if ifweapyn = 'N' then
 begin
   write('What shall the minimum damage be : ');
   readln(u.umindam);
 end;
  write('Maximum damage will be [',u.umaxdam,']');
  readln(ifweapyn);
  ifweapyn:=upcase(ifweapyn);
    if ifweapyn = 'N' then
 begin
   write('What shall the maximum damage be : ');
   readln(u.umaxdam);
 end;
  write('Duribility will be [',u.uadur,']');
  readln(ifweapyn);
  ifweapyn:=upcase(ifweapyn);
    if ifweapyn = 'N' then
 begin
   write('What shall the duribility be : ');
   readln(u.uadur);
   u.umaxdur:=u.uadur;
 end;
  write('The needed level will be [',u.unlvl,']');
  readln(ifweapyn);
  ifweapyn:=upcase(ifweapyn);
    if ifweapyn = 'N' then
 begin
   write('What shall be the needed level : ');
   readln(u.unlvl);
 end;
  write('The needed strength will be [',u.unstr,']');
  readln(ifweapyn);
  ifweapyn:=upcase(ifweapyn);
    if ifweapyn = 'N' then
 begin
   write('What shall be the needed strength : ');
   readln(u.unstr);
 end;
  write('The needed dexterity will be [',u.undex,']');
  readln(ifweapyn);
  ifweapyn:=upcase(ifweapyn);
    if ifweapyn = 'N' then
 begin
   write('What shall be the needed dexterity : ');
   readln(u.undex);
 end;
     if u.uM = true then
  begin
    write('melee this weapon will be used as : ');
    readln(ifweapyn);
    ifweapyn:=upcase(ifweapyn);
     if ifweapyn = 'N' then
   begin
      repeat
     write('What will this weapon used as then <M>eelee, <R>anged');
     readln(ifweapyn);
      until ifweapyn in ['r','m','R','M'];
    ifweapyn:=upcase(ifweapyn);
      if ifweapyn = 'R' then
     begin
      u.uR:=true;
      u.uM:=false;
     end
       else
     begin
      u.uM:=true;
      u.uR:=false;
     end;
   end;
  end

    else

  begin
    write('Ranged this weapon will be used as : ');
    readln(ifweapyn);
    ifweapyn:=upcase(ifweapyn);
     if ifweapyn = 'N' then
   begin
      repeat
     write('What will this weapon used as then <M>eelee, <R>anged');
     readln(ifweapyn);
      until ifweapyn in ['r','m','R','M'];
    ifweapyn:=upcase(ifweapyn);
      if ifweapyn = 'R' then
     begin
      u.uR:=true;
      u.uM:=false;
     end
       else
     begin
      u.uM:=true;
      u.uR:=false;
     end;
   end;
  end;
     write('This weapon will be ',u.uhandtype,' handed : ');
     readln(ifweapyn);
     ifweapyn:=upcase(ifweapyn);
      if ifweapyn = 'N' then
    begin
     repeat
    writeln('How many hands do you need for this weapon <1>One hand');
    writeln('                                           <2>Two handed');
    readln(u.uhandtype);
     until u.uhandtype in [1,2];
    end;

    clrscr;
    textcolor(green);
    write('Do you want any special poision damage : ');
    readln(ifweapyn);
    ifweapyn:=upcase(ifweapyn);
     if ifweapyn = 'Y' then
  begin
      write('How much extra minimum damage : ');
      readln(u.spec[1]);
      write('How much extra maximum damage : ');
      readln(u.spec[2]);
  end

     else

  begin
      u.spec[1]:=0;
      u.spec[2]:=0;
  end;

    textcolor(red);
    write('Do you want any extra fire damage : ');
    readln(ifweapyn);
    ifweapyn:=upcase(ifweapyn);
     if ifweapyn = 'Y' then
  begin
      write('How much extra minimum damage : ');
      readln(u.spec[3]);
      write('How much extra maximum damage : ');
      readln(u.spec[4]);
  end

     else

  begin
      u.spec[3]:=0;
      u.spec[4]:=0;
  end;

    textcolor(yellow);
    write('Do you want any extra lightning damage : ');
    readln(ifweapyn);
    ifweapyn:=upcase(ifweapyn);
     if ifweapyn = 'Y' then
  begin
      write('How much extra minimum damage : ');
      readln(u.spec[5]);
      write('How much extra maximum damage : ');
      readln(u.spec[6]);
  end

    else

  begin
      u.spec[5]:=0;
      u.spec[6]:=0;
  end;

   textcolor(brown);
   write('Do you want any extra Earth damage : ');
   readln(ifweapyn);
   ifweapyn:=upcase(ifweapyn);
    if ifweapyn = 'Y' then
  begin
      write('How much extra minimum damage : ');
      readln(u.spec[7]);
      write('How much extra maximum damage : ');
      readln(u.spec[8]);
  end

    else

  begin
      u.spec[7]:=0;
      u.spec[8]:=0;
  end;

   textcolor(blue);
   write('Do you want any extra Cold damage : ');
   readln(ifweapyn);
   ifweapyn:=upcase(ifweapyn);
    if ifweapyn = 'Y' then
  begin
      write('How much extra minimum damage : ');
      readln(u.spec[9]);
      write('How much extra maximum damage : ');
      readln(u.spec[10]);
  end

    else

  begin
      u.spec[9]:=0;
      u.spec[10]:=0;
  end;

   textcolor(lightgray);
   write('Do you want any extra evil damage : ');
   readln(ifweapyn);
   ifweapyn:=upcase(ifweapyn);
    if ifweapyn = 'Y' then
  begin
      write('How much extra minimum damage : ');
      readln(u.spec[11]);
      write('How much extra maximum damage : ');
      readln(u.spec[12]);
  end

    else

  begin
      u.spec[11]:=0;
      u.spec[12]:=0;
  end;

   textcolor(red);
   write('What will be the extra health (if none type 0) : ');
   readln(u.uehp);

   textcolor(blue);
   write('What will be the extra mana (if none type 0) : ');
   readln(u.uemana);

   textcolor(white);
   write('What will be the extra strength (if none type 0) : ');
   readln(u.uestr);

   write('What will be the extra dexterity (if none type 0) : ');
   readln(u.uedex);

   write('What will be the extra intelligence (if none type 0) : ');
   readln(u.ueint);

   write('What will be the extra armour (if none type 0) : ');
   readln(u.uearm);

  clrscr;
  textcolor(yellow);
  writeln('So far this is the weapon...');
  writeln('Name := ',u.uniweaptitle,' ',u.uniweapname);
  writeln('     Base Damage := ',u.umindam,' to ',u.umaxdam);
  writeln('     Duribility  := ',u.uadur,' of ',u.umaxdur);
  writeln('     Needed level      := ',u.unlvl);
  writeln('     Needed Strength   := ',u.unstr);
  writeln('     Needed Duribility := ',u.undex);
   if u.uM = true then
 begin
  writeln('     Weapon Type := melee');
 end

   else

 begin
  writeln('     Weapon Type := Ranged');
 end;
   if u.uhandtype = 1 then
 begin
  writeln('     One handed');
 end

   else
 begin
  writeln('     Two handed');
 end;

 writeln;

   if u.spec[1] > 0 then
begin
  writeln('Poison damage = ',u.spec[1],' to ',u.spec[2]);
end;

   if u.spec[3] > 0 then
begin
  writeln('Fire damage = ',u.spec[3],' to ',u.spec[4]);
end;
   if u.spec[5] > 0 then
begin
  writeln('Lightning damage = ',u.spec[5],' to ',u.spec[6]);
end;
   if u.spec[7] > 0 then
begin
  writeln('Earth damage = ',u.spec[7],' to ',u.spec[8]);
end;
   if u.spec[9] > 0 then
begin
  writeln('Cold damage = ',u.spec[9],' to ',u.spec[10]);
end;
   if u.spec[11] > 0 then
begin
  writeln('Evil damage = ',u.spec[11],' to ',u.spec[12]);
end;

   if u.uehp > 0 then
begin
  writeln('Extra Health = ',u.uehp);
end;
   if u.uemana > 0 then
begin
  writeln('Extra Mana = ',u.uemana);
end;
   if u.uestr > 0 then
begin
  writeln('Extra Strength = ',u.uestr);
end;
   if u.uedex > 0 then
begin
  writeln('Extra Dexterity = ',u.uedex);
end;
   if u.uearm > 0 then
begin
  writeln('Extra Armour = ',u.uearm);
end;
   if u.ueint > 0 then
begin
  writeln('Extra intelligence = ',u.ueint);
end;


 writeln;
  repeat
 write('Are you sure this what you want (If n then this program will close) :');
 readln(ifweapyn);
  until ifweapyn in ['y','n','Y','N'];
   ifweapyn:=upcase(ifweapyn);
  if ifweapyn = 'N' then
begin
 halt(0);
end

   else

  if ifweapyn = 'Y' then
 begin
  clrscr;
  writeln('File created c:\tp\turbo\amenc\items\'+w.weapname+'.itw');
  assign(z, 'c:\tp\turbo\amenc\items\'+w.weapname+'.itw');
  rewrite(z);
  write(z, w);
  close(z);
  readln;

  writeln('File created c:\tp\turbo\amenc\items\'+u.uniweapname+'.uiw');
  assign(x, 'c:\tp\turbo\amenc\items\'+u.uniweapname+'.uiw');
  rewrite(x);
  write(x, u);
  close(x);
  readln;
 end;
end;

Procedure statsuni;
begin
  clrscr;
  write('What will the minimum damage be : ');
  readln(u.umindam);
  write('What will the maximum damage be : ');
  readln(u.umaxdam);
  write('What will the duribility be : ');
  readln(u.uadur);
  u.umaxdur:=u.uadur;
  write('What will the needed strength be : ');
  readln(u.unstr);
  write('What will the needed dexterity be : ');
  readln(u.undex);
  write('What will the needed level be : ');
  readln(u.unlvl);
  clrscr;
   repeat
  write('What will the weapon used as <M>eelee, <R>anged');
  readln(ifweapyn);
   until ifweapyn in ['m','r','M','R'];
  ifweapyn:=upcase(ifweapyn);
    if ifweapyn = 'M' then
 begin
  u.uM:=true;
  u.uR:=false;
 end

   else

 begin
  u.uM:=false;
  u.uR:=true;
 end;

   repeat
  clrscr;
  writeln('How many hands are to be used on this weapon <1> One handed');
  writeln('                                             <2> Two handed');
  readln(u.uhandtype);
   until u.uhandtype in [1,2];
 ustatche;
end;

Procedure Createunique;
begin
  clrscr;
  write('What is the title of the unique weapon : ');
  readln(u.uniweaptitle);
  u.uniweapname:=w.weapname;
   repeat
  clrscr;
  write('So the name will be ',u.uniweaptitle,' ',u.uniweapname,' : ');
  readln(ifweapyn);
   until ifweapyn in ['y','n','Y','N'];
  ifweapyn:=upcase(ifweapyn);
    if ifweapyn = 'N' then
 begin
   createunique;
 end;
  statsuni;
end;

Procedure file_create;
begin
  clrscr;
  write('Minimum damage will be [',w.mindam,']');
  readln(ifweapyn);
  ifweapyn:=upcase(ifweapyn);
    if ifweapyn = 'N' then
 begin
   write('What shall the minimum damage be : ');
   readln(w.mindam);
 end;
  write('Maximum damage will be [',w.maxdam,']');
  readln(ifweapyn);
  ifweapyn:=upcase(ifweapyn);
    if ifweapyn = 'N' then
 begin
   write('What shall the maximum damage be : ');
   readln(w.maxdam);
 end;
  write('Duribility will be [',w.adur,']');
  readln(ifweapyn);
  ifweapyn:=upcase(ifweapyn);
    if ifweapyn = 'N' then
 begin
   write('What shall the duribility be : ');
   readln(w.adur);
   w.maxdur:=w.adur;
 end;
  write('The needed level will be [',w.nlvl,']');
  readln(ifweapyn);
  ifweapyn:=upcase(ifweapyn);
    if ifweapyn = 'N' then
 begin
   write('What shall be the needed level : ');
   readln(w.nlvl);
 end;
  write('The needed strength will be [',w.nstr,']');
  readln(ifweapyn);
  ifweapyn:=upcase(ifweapyn);
    if ifweapyn = 'N' then
 begin
   write('What shall be the needed strength : ');
   readln(w.nstr);
 end;
  write('The needed dexterity will be [',w.ndex,']');
  readln(ifweapyn);
  ifweapyn:=upcase(ifweapyn);
    if ifweapyn = 'N' then
 begin
   write('What shall be the needed dexterity : ');
   readln(w.ndex);
 end;
     if w.M = true then
  begin
    write('melee this weapon will be used as : ');
    readln(ifweapyn);
    ifweapyn:=upcase(ifweapyn);
     if ifweapyn = 'N' then
   begin
      repeat
     write('What will this weapon used as then <M>eelee, <R>anged');
     readln(ifweapyn);
      until ifweapyn in ['r','m','R','M'];
    ifweapyn:=upcase(ifweapyn);
      if ifweapyn = 'R' then
     begin
      w.R:=true;
      w.M:=false;
     end
       else
     begin
      w.M:=true;
      w.R:=false;
     end;
   end;
  end

    else

  begin
    write('Ranged this weapon will be used as : ');
    readln(ifweapyn);
    ifweapyn:=upcase(ifweapyn);
     if ifweapyn = 'N' then
   begin
      repeat
     write('What will this weapon used as then <M>eelee, <R>anged');
     readln(ifweapyn);
      until ifweapyn in ['r','m','R','M'];
    ifweapyn:=upcase(ifweapyn);
      if ifweapyn = 'R' then
     begin
      w.R:=true;
      w.M:=false;
     end
       else
     begin
      w.M:=true;
      w.R:=false;
     end;
   end;
  end;
     write('This weapon will be ',w.handtype,' handed : ');
     readln(ifweapyn);
     ifweapyn:=upcase(ifweapyn);
      if ifweapyn = 'N' then
    begin
     repeat
    writeln('How many hands do you need for this weapon <1>One hand');
    writeln('                                           <2>Two handed');
    readln(w.handtype);
     until w.handtype in [1,2];
    end;


  clrscr;
  writeln('So far this is the weapon...');
  writeln('Name := ',w.weapname);
  writeln('     Base Damage := ',w.mindam,' to ',w.maxdam);
  writeln('     Duribility  := ',w.adur,' of ',w.maxdur);
  writeln('     Needed level      := ',w.nlvl);
  writeln('     Needed Strength   := ',w.nstr);
  writeln('     Needed Duribility := ',w.ndex);
   if w.M = true then
 begin
  writeln('     Weapon Type := melee');
 end

   else

 begin
  writeln('     Weapon Type := Ranged');
 end;
   if w.handtype = 1 then
 begin
  writeln('     One handed');
 end

   else
 begin
  writeln('     Two handed');
 end;

 writeln;
  repeat
 write('Are you sure this what you want (If n then this program will close) :');
 readln(ifweapyn);
  until ifweapyn in ['y','n','Y','N'];
   ifweapyn:=upcase(ifweapyn);
  if ifweapyn = 'N' then
begin
 halt(0);
end;

  assign(z, 'c:\tp\turbo\amenc\items\'+w.weapname+'.itw');
  rewrite(z);
  write(z, w);
  close(z);
   repeat
 clrscr;

 write('Is this weapon going to have a unquie version :');
 readln(ifweapyn);
   until ifweapyn in ['y','n','Y','N'];
    ifweapyn:=upcase(ifweapyn);
  if ifweapyn = 'Y' then
begin
  createunique;
end

  else
begin
  clrscr;
  writeln('File Created c:\tp\turbo\amenc\items\'+w.weapname+'.itw');
readln;
end;
end;

Procedure normal;
 begin
  clrscr;
  write('What is the name of the weapon you want to convert : ');
  readln(preweap);
  assign(z, 'c:\tp\turbo\amenc\items\'+preweap+'.itw');
  reset(z);
  read(z, w);
  close(z);
   repeat
  clrscr;
  writeln('This is the weapon...');
  writeln('Type save to keep changes, type quit to exit.');
  writeln('Name := ',w.weapname);
  writeln('     Base Damage := ',w.mindam,' to ',w.maxdam);
  writeln('     Duribility  := ',w.adur,' of ',w.maxdur);
  writeln('     Needed level      := ',w.nlvl);
  writeln('     Needed Strength   := ',w.nstr);
  writeln('     Needed Duribility := ',w.ndex);
   if w.M = true then
 begin
  writeln('     Weapon Type := melee');
 end

   else

 begin
  writeln('     Weapon Type := Ranged');
 end;
   if w.handtype = 1 then
 begin
  writeln('     One handed');
 end

   else
 begin
  writeln('     Two handed');
 end;

 write('What do you want to change : ');
 readln(preweap);
   for count:=1 to length(preweap) do
  preweap[count]:=upcase(preweap[count]);

   if (preweap = 'DAMAGE') or (preweap = 'DAMAG') or
   (preweap = 'DAMA') or (preweap = 'DAM') or
   (preweap = 'DA') then
 begin
   write('What do you want the minimum damage to be :');
   readln(w.mindam);
   write('What do you want the maximum damage to be :');
   readln(w.maxdam);
 end

   else

   if (preweap = 'DURIBILITY') or (preweap = 'DURIBILIT') or
   (preweap = 'DURIBILI') or (preweap = 'DURIBIL') or
   (preweap = 'DURIBI') or (preweap = 'DURIB') or
   (preweap = 'DURI') or (preweap = 'DUR') or
   (preweap = 'DU') then
 begin
   write('What do you want the duribility to be : ');
   readln(w.adur);
   w.maxdur:=w.adur;
 end

   else

   if (preweap = 'NEEDED LEVEL') or (preweap = 'NEEDED LEVE') or
   (preweap = 'NEEDED LEV') or (preweap = 'NEEDED LE') or
   (preweap = 'NEEDED L') then
 begin
   write('What do you want the needed level to be : ');
   readln(w.nlvl);
 end

   else

   if (preweap = 'NEEDED STRENGTH') or (preweap = 'NEEDED STRENGT') or
   (preweap = 'NEEDED STRENG') or (preweap = 'NEEDED STREN') or
   (preweap = 'NEEDED STRE') or (preweap = 'NEEDED STR') or
   (preweap = 'NEEDED ST') or (preweap = 'NEEDED S') then
 begin
   write('What do you want the needed strength to be : ');
   readln(w.nstr);
 end

   else

   if (preweap = 'NEEDED DEXTERITY') or (preweap = 'NEEDED DEXTERIT') or
   (preweap = 'NEEDED DEXTERI') or (preweap = 'NEEDED DEXTER') or
   (preweap = 'NEEDED DEXTE') or (preweap = 'NEEDED DEXT') or
   (preweap = 'NEEDED DEX') or (preweap = 'NEEDED DE') or
   (preweap = 'NEEDED D') then
 begin
   write('What do you want the needed dexterity to be : ');
   readln(w.ndex);
 end

   else

   if (preweap = 'WEAPON TYPE') or (preweap = 'WEAPON TYP') or
   (preweap = 'WEAPON TY') or (preweap = 'WEAPON T') or
   (preweap = 'WEAPON ') or (preweap = 'WEAPON') or
   (preweap = 'WEAPO') or (preweap = 'WEAP') or
   (preweap = 'WEA') or (preweap = 'WE') or
   (preweap = 'W') then
 begin
     repeat
   write('What will the new weapon type be <M>eelee, <R>anged');
   readln(ifweapyn);
     until ifweapyn in ['r','m','M','R'];
  ifweapyn:=upcase(ifweapyn);
    if ifweapyn = 'R' then
 begin
  w.R:=true;
  w.M:=false;
 end

   else

 begin
  w.R:=false;
  w.M:=true;
 end;
 end

   else

   if (preweap = 'HANDS') or (preweap = 'HAND') or
   (preweap = 'HAN') or (preweap = 'HA') or
   (preweap = 'H') then
 begin
    repeat
   writeln('How many hands do you need for this weapon <1>One hand');
   writeln('                                           <2>Two handed');
   readln(w.handtype);
    until w.handtype in [1,2];
 end

   else

   if (preweap = 'SAVE') or (preweap ='SAV') or
   (preweap = 'SA') then
 begin
   writeln('Saving weapon...');
     assign(z, 'c:\tp\turbo\amenc\items\'+w.weapname+'.itw');
     reset(z);
     write(z, w);
     close(z);
   writeln('Save complete!');
   readln;
 end;

    until (preweap = 'QUIT') or (preweap = 'QUI') or
    (preweap = 'QU') or (preweap = 'Q');

   If (preweap = 'QUIT') or (preweap = 'QUI') or
    (preweap = 'QU') or (preweap = 'Q') then
 begin
    repeat
   write('Are you sure you want to quit : ');
   readln(ifweapyn);
    until ifweapyn in ['y','n','Y','N'];
  ifweapyn:=upcase(ifweapyn);
  if ifweapyn = 'Y' then
 begin
   halt(0);
 end
  else normal;
 end;
end;

Procedure unique;
begin
  clrscr;
  write('What is the name of the weapon you want to convert : ');
  readln(preweap);
  assign(x, 'c:\tp\turbo\amenc\items\'+preweap+'.uiw');
  reset(x);
  read(x, u);
  close(x);
   repeat
  clrscr;
  writeln('This is the weapon...');
  writeln('Type save to keep changes, type quit to exit.');
  writeln('Name := ',u.uniweaptitle,' ',u.uniweapname);
  writeln('     Base Damage := ',u.umindam,' to ',u.umaxdam);
  writeln('     Duribility  := ',u.uadur,' of ',u.umaxdur);
  writeln('     Needed level      := ',u.unlvl);
  writeln('     Needed Strength   := ',u.unstr);
  writeln('     Needed Duribility := ',u.undex);
   if u.uM = true then
 begin
  writeln('     Weapon Type := melee');
 end

   else

 begin
  writeln('     Weapon Type := Ranged');
 end;
   if u.uhandtype = 1 then
 begin
  writeln('     One handed');
 end

   else
 begin
  writeln('     Two handed');
 end;

 writeln;

   if u.spec[1] > 0 then
begin
  textcolor(green);
  writeln('Poison damage = ',u.spec[1],' to ',u.spec[2]);
end;

   if u.spec[3] > 0 then
begin
  textcolor(red);
  writeln('Fire damage = ',u.spec[3],' to ',u.spec[4]);
end;
   if u.spec[5] > 0 then
begin
  textcolor(yellow);
  writeln('Lightning damage = ',u.spec[5],' to ',u.spec[6]);
end;
   if u.spec[7] > 0 then
begin
  textcolor(brown);
  writeln('Earth damage = ',u.spec[7],' to ',u.spec[8]);
end;
   if u.spec[9] > 0 then
begin
  textcolor(blue);
  writeln('Cold damage = ',u.spec[9],' to ',u.spec[10]);
end;
   if u.spec[11] > 0 then
begin
  textcolor(lightgray);
  writeln('Evil damage = ',u.spec[11],' to ',u.spec[12]);
end;

   if u.uehp > 0 then
begin
  textcolor(red);
  writeln('Extra Health = ',u.uehp);
end;
   if u.uemana > 0 then
begin
  textcolor(blue);
  writeln('Extra Mana = ',u.uemana);
end;
   if u.uestr > 0 then
begin
  writeln('Extra Strength = ',u.uestr);
end;
   if u.uedex > 0 then
begin
  writeln('Extra Dexterity = ',u.uedex);
end;
   if u.uearm > 0 then
begin
  writeln('Extra Armour = ',u.uearm);
end;
   if u.ueint > 0 then
begin
  writeln('Extra intelligence = ',u.ueint);
end;

 textcolor(yellow);
 write('What do you want to change : ');
 readln(preweap);
   for count:=1 to length(preweap) do
  preweap[count]:=upcase(preweap[count]);

   if (preweap = 'DAMAGE') or (preweap = 'DAMAG') or
   (preweap = 'DAMA') or (preweap = 'DAM') or
   (preweap = 'DA') then
 begin
   write('What do you want the minimum damage to be :');
   readln(u.umindam);
   write('What do you want the maximum damage to be :');
   readln(u.umaxdam);
 end

   else

   if (preweap = 'HEALTH') or (preweap = 'HEALT') or
   (preweap = 'HEAL') or (preweap = 'HEA') or
   (preweap = 'HE') then
 begin
   write('What will be the extra health (if none type 0) : ');
   readln(u.uehp);
 end

   else

   if (preweap = 'MANA') or (preweap = 'MAN') or
   (preweap = 'MA') then
 begin
   write('What will be the extra mana (if nonw type 0) : ');
   readln(u.uemana);
 end

   else

   if (preweap = 'STRENGTH') or (preweap = 'STRENGT') or
   (preweap = 'STRENG') or (preweap = 'STREN') or
   (preweap = 'STRE') or (preweap = 'STR') or
   (preweap = 'ST') then
 begin
   write('What will be the extra strength (if none type 0) : ');
   readln(u.uestr);
 end

   else

   if (preweap = 'DEXTERITY') or (preweap = 'DEXTERIT') or
   (preweap = 'DEXTERI') or (preweap = 'DEXTER') or
   (preweap = 'DEXTE') or (preweap = 'DEXT') or
   (preweap = 'DEX') or (preweap = 'DE') then
 begin
   write('What will be the extra dexterity (if none type 0) : ');
   readln(u.uedex);
 end

   else

   if (preweap = 'intelligence') or (preweap = 'INTELLIGANC') or
   (preweap = 'INTELLIGA') or (preweap = 'INTELLIG') or
   (preweap = 'INTELLI') or (preweap = 'INTELL') or
   (preweap = 'INTEL') or (preweap = 'INTE') or
   (preweap = 'INT') or (preweap = 'IN') then
 begin
   write('What will be the extra intelligence (if none type 0) : ');
   readln(u.ueint);
 end

   else

   if (preweap = 'ARMOUR') or (preweap = 'ARMOU') or
   (preweap = 'ARMO') or (preweap = 'ARM') or
   (preweap = 'AR') then
 begin
   write('What will be the extra armour (if none type 0) : ');
   readln(u.uearm);
 end

   else

   if (preweap = 'POISON') or (preweap = 'POISO') or
   (preweap = 'POIS') or (preweap = 'POI') or
   (preweap = 'PO') then
 begin
   write('What will be the minimum poison damage : ');
   readln(u.spec[1]);
   write('What will be the maximum poison damage : ');
   readln(u.spec[2]);
 end

   else

   if (preweap = 'FIRE') or (preweap = 'FIR') or
   (preweap = 'FI') then
 begin
   write('What will be the minimum fire damage : ');
   readln(u.spec[3]);
   write('What will be the maximum fire damage : ');
   readln(u.spec[4]);
 end

   else

   if (preweap = 'LIGHTNING') or (preweap = 'LIGHTNIN') or
   (preweap = 'LIGHTN') or (preweap = 'LIGHT') or
   (preweap = 'LIGH') or (preweap = 'LIG') or
   (preweap = 'LI') then
 begin
   write('What will be the minimum lightning damage : ');
   readln(u.spec[5]);
   write('What will be the maximum lightning damage : ');
   readln(u.spec[6]);
 end

   else

   if (preweap = 'EARTH') or (preweap = 'EART') or
   (preweap = 'EAR') or (preweap = 'EA') then
 begin
   write('What will be the minimum Earth damage : ');
   readln(u.spec[7]);
   write('What will be the maximum Earth damage : ');
   readln(u.spec[8]);
 end

   else

   if (preweap = 'COLD') or (preweap = 'COL') or
   (preweap = 'CO') then
 begin
   write('What will be the minimum Cold damage : ');
   readln(u.spec[9]);
   write('What will be the maximum Cold damage : ');
   readln(u.spec[10]);
 end

   else

   if (preweap = 'EVIL') or (preweap = 'EVI') or
   (preweap = 'EV') then
 begin
   write('What will be the minimum Evil damage : ');
   readln(u.spec[11]);
   write('What will be the maximum Evil damage : ');
   readln(u.spec[12]);
 end

   else

   if (preweap = 'DURIBILITY') or (preweap = 'DURIBILIT') or
   (preweap = 'DURIBILI') or (preweap = 'DURIBIL') or
   (preweap = 'DURIBI') or (preweap = 'DURIB') or
   (preweap = 'DURI') or (preweap = 'DUR') or
   (preweap = 'DU') then
 begin
   write('What do you want the duribility to be : ');
   readln(u.uadur);
   u.umaxdur:=u.uadur;
 end

   else

   if (preweap = 'NEEDED LEVEL') or (preweap = 'NEEDED LEVE') or
   (preweap = 'NEEDED LEV') or (preweap = 'NEEDED LE') or
   (preweap = 'NEEDED L') then
 begin
   write('What do you want the needed level to be : ');
   readln(u.unlvl);
 end

   else

   if (preweap = 'NEEDED STRENGTH') or (preweap = 'NEEDED STRENGT') or
   (preweap = 'NEEDED STRENG') or (preweap = 'NEEDED STREN') or
   (preweap = 'NEEDED STRE') or (preweap = 'NEEDED STR') or
   (preweap = 'NEEDED ST') or (preweap = 'NEEDED S') then
 begin
   write('What do you want the needed strength to be : ');
   readln(u.unstr);
 end

   else

   if (preweap = 'NEEDED DEXTERITY') or (preweap = 'NEEDED DEXTERIT') or
   (preweap = 'NEEDED DEXTERI') or (preweap = 'NEEDED DEXTER') or
   (preweap = 'NEEDED DEXTE') or (preweap = 'NEEDED DEXT') or
   (preweap = 'NEEDED DEX') or (preweap = 'NEEDED DE') or
   (preweap = 'NEEDED D') then
 begin
   write('What do you want the needed dexterity to be : ');
   readln(u.undex);
 end

   else

   if (preweap = 'WEAPON TYPE') or (preweap = 'WEAPON TYP') or
   (preweap = 'WEAPON TY') or (preweap = 'WEAPON T') or
   (preweap = 'WEAPON ') or (preweap = 'WEAPON') or
   (preweap = 'WEAPO') or (preweap = 'WEAP') or
   (preweap = 'WEA') or (preweap = 'WE') or
   (preweap = 'W') then
 begin
     repeat
   write('What will the new weapon type be <M>eelee, <R>anged');
   readln(ifweapyn);
     until ifweapyn in ['r','m','M','R'];
  ifweapyn:=upcase(ifweapyn);
    if ifweapyn = 'R' then
 begin
  u.uR:=true;
  u.uM:=false;
 end

   else

 begin
  u.uR:=false;
  u.uM:=true;
 end;
 end

   else

   if (preweap = 'HANDS') or (preweap = 'HAND') or
   (preweap = 'HAN') or (preweap = 'HA') or
   (preweap = 'H') then
 begin
    repeat
   writeln('How many hands do you need for this weapon <1>One hand');
   writeln('                                           <2>Two handed');
   readln(u.uhandtype);
    until u.uhandtype in [1,2];
 end

   else

   if (preweap = 'SAVE') or (preweap ='SAV') or
   (preweap = 'SA') or (preweap = 'S') then
 begin
   writeln('Saving weapon...');
     assign(x, 'c:\tp\turbo\amenc\items\'+u.uniweapname+'.uiw');
     reset(x);
     write(x, u);
     close(x);
   writeln('Save complete!');
   readln;
 end;

    until (preweap = 'QUIT') or (preweap = 'QUI') or
    (preweap = 'QU') or (preweap = 'Q');

   If (preweap = 'QUIT') or (preweap = 'QUI') or
    (preweap = 'QU') or (preweap = 'Q') then
 begin
    repeat
   write('Are you sure you want to quit : ');
   readln(ifweapyn);
    until ifweapyn in ['y','n','Y','N'];
  ifweapyn:=upcase(ifweapyn);
  if ifweapyn = 'Y' then
 begin
   halt(0);
 end
  else unique;
 end;
 end;

Procedure preweapon;
begin
   repeat
  textcolor(yellow);
  Write('What kind of weapon file do you want to convert <U>nique, <N>ormal : ');
  readln(ifweapyn);
   until ifweapyn in ['u','n','U','N'];
  ifweapyn:=upcase(ifweapyn);
   if ifweapyn = 'N' then
begin
  normal;
end

   else

   if ifweapyn = 'U' then
begin
  unique;
end;
end;

Procedure createweap;
begin
    repeat
  clrscr;
  write('Are you sure you want to create a new weapon : ');
  readln(ifweapyn);
    Until ifweapyn in ['y','n','Y','N'];
   if ifweapyn = 'N' then
begin
  halt(0);
end;
  clrscr;
  write('What do you want this weapon to be called : ');
  readln(w.weapname);
  clrscr;
   repeat
  write(w.weapname,' will be the name : ');
  readln(ifweapyn);
   until ifweapyn in ['y','n','Y','N'];
 ifweapyn:=upcase(ifweapyn);
    if ifweapyn = 'N' then
begin
 createweap;
end;
  clrscr;
  textcolor(14);
  writeln('Declaring ',w.weapname,' stats...');
  writeln;
  textcolor(13);
  write('What do you want the minimum damage to be : ');
  readln(w.mindam);
  write('What do you want the maximum damage to be : ');
  readln(w.maxdam);
  write('What do you want the durability to be : ');
  readln(w.adur);
  w.maxdur:=w.adur;
  write('What will be the needed strength : ');
  readln(w.nstr);
  write('What will be the needed dexterity : ');
  readln(w.ndex);
  write('What will be the needed level : ');
  readln(w.nlvl);

  clrscr;
   repeat
  write('What kind of weapon is it : <M>eelee, <R>anged');
  readln(ifweapyn)
   until ifweapyn in ['r','m','R','M'];
  ifweapyn:=upcase(ifweapyn);
    if ifweapyn = 'R' then
begin
  w.M:=false;
  w.R:=true;
end

  else

begin
  w.R:=false;
  w.M:=true;
end;

clrscr;
    repeat
  writeln('What type of hand weapon will this be  1> One Handed');
  writeln('                                       2> Two handed');
  readln(w.handtype);
    until w.handtype in [1,2];
   file_create;
end;

Procedure new;
begin
  clrscr;
    repeat
  write('Have you got a previously created weapon you want to convert : ');
  readln(ifweapyn);
    until ifweapyn in ['y','n','Y','N'];
      ifweapyn:=upcase(ifweapyn);
     if ifweapyn = 'Y' then
begin
    preweapon;
end else createweap;
end;

begin
  menu_window;
  message_window;
  clrscr;
  textcolor(yellow);
  writeln('This program was created by AchromiciA & Crizmal');
  writeln('Copyright has been placed upon this program and no');
  writeln('copying will and should not take place');
  writeln('The only users of this program will be the original creators.');
    readln;
      repeat
  clrscr;
  write('Type in security code : ');
  readln(secode);
    Until secode > '';
     if secode = '56gifcode' then
 begin
   new;
 end  else halt(0);
end.
