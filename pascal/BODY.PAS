Program testgear;
uses crt;

type
Body = record
  LArm, RArm, Lfoot, Rfoot, head, Chest : string;
  Lhand, Rhand, Lfinger, Rfinger, Rleg, Lleg : string;
end;

Lhand = record
  lhhp, lhmana, lhstr, lhdex, lhint, lharm : integer;
  lh : string;
end;

Rhand = record
  rhhp, rhmana, rhstr, rhdex, rhint, rharm : integer;
  rh : string;
end;

Lleg = record
  llhp, llmana, llstr, lldex, llint, llarm : integer;
  ll : string;
end;

Rleg = record
  rlhp, rlmana, rlstr, rldex, rlint, rlarm : integer;
  rl : string;
end;

Chest = record
  chp, cmana, cstr, cdex, cint, carm : integer;
  c : string;
end;

var
  gearyn : char;
  count : integer;
  maincom : string;
  cf : file of chest;
  cs : chest;
  z : file of body;
  b : body;
  hp, mana, str, dex, int, arm : integer;

Procedure start;
begin
  clrscr;
   repeat
  write('<Main command>');
  readln(maincom);
 for count := 1 to length(maincom) do
  maincom[count]:=upcase(maincom[count]);

  if (maincom = 'WEAR QUILTED') or (maincom = 'WEAR QUILTE') or
  (maincom = 'WEAR QUILT') or (maincom = 'WEAR QUIL') or
  (maincom = 'WEAR QUI') or (maincom = 'WEAR QU') or
  (maincom = 'WEAR Q') then
 begin
   writeln('Quilted armour worn.');
  assign(cf, 'c:\tp\turbo\amenc\items\quilted.itm');
  reset(cf);
  read(cf, cs);
  close(cf);
   hp:=hp+cs.chp;
   mana:=mana+cs.cmana;
   str:=str+cs.cstr;
   dex:=dex+cs.cdex;
   int:=int+cs.cint;
   arm:=arm+cs.carm;
   b.chest:='Quilted Armour';
 end

   else

  if (maincom = 'STA') then
 begin
   writeln('Health = ', hp);
   writeln('Mana = ',mana);
   writeln('Strength = ', str);
   writeln('Dexterity = ',dex);
   writeln('Armour = ',arm);
   writeln('Intelligence = ',int);
   writeln(b.chest);
 end

   else

  if (maincom = 'REM QUILTED') or (maincom = 'REM QUILTE') or
  (maincom = 'REM QUILT') or (maincom = 'REM QUIL') or
  (maincom = 'REM QUI') or (maincom = 'REM QU') or
  (maincom = 'REM Q') then
 begin
   writeln('Quilted armour removed!');
   hp:=hp-cs.chp;
   mana:=mana-cs.cmana;
   str:=str-cs.cstr;
   dex:=dex-cs.cdex;
   int:=int-cs.cint;
   arm:=arm-cs.carm;
   b.Chest:='(Nothing)';
 end;

   until maincom = 'Q';

 halt(0);
end;

Procedure newstats;
begin
  Str:=15;
  Dex:=20;
  Int:=18;
  Arm:=8;
  hp:=100;
  mana:=20;
  b.chest:='(Nothing)';
end;

begin
  newstats;
  start;
end.