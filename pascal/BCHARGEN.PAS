Program CharGen;
Uses Crt;


Type
  Character = record
    Name : string[20];
    Type1 : char;
    CurHp, CurMana : integer;
    MaxMass, MaxInv : integer;
    Str, Dex, Int, Vit, Ene : integer;
    Expg, Expn, Lvl : integer;
    WECoor, NSCoor : integer
    MinDam, MaxDam : integer;
  end;

Var
  temp : string;
  Qes, New: char;
  Stats : Character;
  charfile : file of Character;
  count, tick : integer;
  h, m, s, d, hund, diff,x , y : word;
  time, comptime : longint;
  TextColour, BackColour : Byte;
  Sleep, Rest : Boolean;
  Timer : integer;
  Description : string[255];
  Area : String[100];


Procedure Save;
begin
  Writeln('Saving character ', Stats.Name,'...');

  Assign(charfile, Stats.Name + '.dcs');
  ReWrite(charfile);
  Write(charfile, Stats);
  Close(charfile);

  Writeln('Character Saved!');
  Qes := ReadKey;
end;

Var
   i : Integer;
   Key : Char;
   Class : Char;
   ClassName : String;
   Strength: Integer;
   Intelligence : Integer;
   Wisdom : Integer;
   Dexterity : Integer;
   Constitution : Integer;
   Charisma : Integer;
   StrengthMod: Integer;
   IntelligenceMod : Integer;
   WisdomMod : Integer;
   DexterityMod : Integer;
   ConstitutionMod : Integer;
   CharismaMod : Integer;
   Statistic : Integer;
   Modifier : Integer;
   CharGold : Integer;
   CharExperience : Longint;
   MaxHP : Integer;
   CurHP : Integer;
   CharFile : String[8];
   CharName : String[15];



Function DetermineStatMod (Statistic:Integer): Integer;
begin
     Case Statistic of
     3 : DetermineStatMod:=-3;
     4..5 : DetermineStatMod:=-2;
     6..8 : DetermineStatMod:=-1;
     9..12 : DetermineStatMod:=0;
     13..15 : DetermineStatMod:=1;
     16..17 : DetermineStatMod:=2;
     18 : DetermineStatMod:=3;
     end;
end;

Function Roll (i:integer) : Integer;
begin
     Roll:=Random(i)+1;
end;

Procedure Statistics;
begin
     {Roll Statistics}
     Strength:=Roll(6)+Roll(6)+Roll(6);
     Intelligence:=Roll(6)+Roll(6)+Roll(6);
     Wisdom:=Roll(6)+Roll(6)+Roll(6);
     Dexterity:=Roll(6)+Roll(6)+Roll(6);
     Constitution:=Roll(6)+Roll(6)+Roll(6);
     Charisma:=Roll(6)+Roll(6)+Roll(6);

     {Determine Modifiers}
     StrengthMod:=DetermineStatMod(Strength);
     IntelligenceMod:=DetermineStatMod(Intelligence);
     WisdomMod:=DetermineStatMod(Wisdom);
     DexterityMod:=DetermineStatMod(Dexterity);
     ConstitutionMod:=DetermineStatMod(Constitution);
     CharismaMod:=DetermineStatMod(Charisma);

end;

Procedure ChooseClass;
begin
     {Display Abilities}
     textcolor(yellow);
     writeln('Your character`s Ability Scores have been determined: ');
     writeln;
     textcolor(white);
     writeln('Ability       ','Score',     ' Modifier');
     writeln('Strength:     ',Strength,    '    ',StrengthMod);
     writeln('Intelligence: ',Intelligence,'    ',IntelligenceMod);
     writeln('Wisdom:       ',Wisdom,      '    ',WisdomMod);
     writeln('Dexterity:    ',Dexterity,   '    ',DexterityMod);
     writeln('Constitution: ',Constitution,'    ',ConstitutionMod);
     writeln('Charisma:     ',Charisma,    '    ',CharismaMod);
     writeln;

     {Present Classes}
     textcolor(yellow);
     writeln('You must choose one of the following classes - ');
     textcolor(white);
     writeln('(c) Cleric (not available)');
     writeln('(f) Fighter');
     writeln('(m) Magic User (not available)');
     writeln('(t) Thief (not available)');
     writeln('(d) Dwarf (not available)');
     writeln('(e) Elf (not available)');
     writeln('(h) Halfling (not available)');

     {Wait for choice of Class}
     repeat
           Class:=ReadKey;
           Class:=UpCase(Class);
     until Class in ['F'];

     {Determine Name of Class for future use}

     Case Class of
     'F' : ClassName:='Fighter'
     end;

     {Display Name of Chosen Class}

     writeln;
     textcolor(yellow); writeln('You have chosen to be a ',ClassName);
     textcolor(cyan); writeln('Press any key to continue');

     ReadKey;

end;

Procedure FinishDetails;
begin
     CharGold:=(Roll(6)+Roll(6)+Roll(6))*10;
     CharExperience:=0;

     {Determine Class Related Attributes}

     Case Class of
     'F' : begin;
     MaxHP:=8+ConstitutionMod;
     end;
     end;

     {Present final statistics and ask for name}
     ClrScr;

     textcolor(yellow);
     writeln('Your final starting character details have been created.');
     textcolor(white);
     writeln('Starting Gold - ',CharGold,' GP');
     writeln('Starting Experience - ',CharExperience,' XP');
     writeln('Starting Hit Points - ',MaxHP,' HP');
     writeln;
     textcolor(yellow);
     write('What do you wish to call your character?');
     readln(CharName);

end;

Procedure SaveChar;
begin
     assign(CharFile, CharName + '.csf');
     close(CharFile);
end;

begin
ClrScr;
Randomize;
Statistics;
ChooseClass;
FinishDetails;
SaveChar;
ReadKey;
end.
