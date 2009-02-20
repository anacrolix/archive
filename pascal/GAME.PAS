Program CharGen;
Uses Crt, Dos;

Type
 Character = Record
   {}Class : Char;
   {}ClassMod,GP,Level,
   AC,Damage,DamageBonus,HitBonus,MaxHP,CurHP,
   Str,Intel,Wis,Dex,Con,Cha,
   StrMod,IntelMod,WisMod,DexMod,ConMod,ChaMod
   : Integer;
   {}XP : Longint;
   {}Name : String[15];
   {}ClassName,
   Weapon,Armor,Shield,Equip1,Equip2,Equip3 : String;
   end;
 Monster=Record
   Name : String;
   HP : Integer;
   AC : Integer;
   Hit : Integer;
   Damage : Integer;
   BonusDamage : Integer;
   XP : Integer;
   GP : Integer;
   end;

Var
   i,i2,i3,
   Statistic,Modifer
   : Integer;
   Key : Char;
   Key2 : Char;
   Key3 : Char;

   CharFile : File of Character;

   Char : Character;
   Mon : Monster;
   Temp : String;
   Temp2 : String;
   Temp3 : String;

   hit : Integer;
   dam : Integer;


   Done : Boolean;
   Mana : Integer;
   ACBonus : Integer;




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

Function MultiDice (NumDice,MaxNum: Integer) : integer;
begin
     i:=0;
     for i := 1 to NumDice do
     i:=Random(i)+1;

end;

Function XPNeeded : LongInt;
begin
  case Char.Class of
    'F','H' : begin
      case Char.Level of
      1 : XPNeeded:=200;
      2 : XPNeeded:=400;
      3 : XPNeeded:=800;
      4 : XPNeeded:=1600;
      5 : XPNeeded:=3200;
      6 : XPNeeded:=6400;
      7 : XPNeeded:=12500;
      8 : XPNeeded:=25000;
      end;
    end;
    'M' : begin
      case Char.Level of
      1 : XPNeeded:=250;
      2 : XPNeeded:=500;
      3 : XPNeeded:=1000;
      4 : XPNeeded:=2000;
      5 : XPNeeded:=4000;
      6 : XPNeeded:=8000;
      7 : XPNeeded:=16000;
      8 : XPNeeded:=28000;
      end;
    end;
    'E' : begin
      case Char.Level of
      1 : XPNeeded:=400;
      2 : XPNeeded:=800;
      3 : XPNeeded:=1600;
      4 : XPNeeded:=3200;
      5 : XPNeeded:=6400;
      6 : XPNeeded:=12500;
      7 : XPNeeded:=25000;
      8 : XPNeeded:=40000;
      end;
    end;
    'C' : begin
      case Char.Level of
      1 : XPNeeded:=150;
      2 : XPNeeded:=300;
      3 : XPNeeded:=600;
      4 : XPNeeded:=1200;
      5 : XPNeeded:=2500;
      6 : XPNeeded:=5000;
      7 : XPNeeded:=10000;
      8 : XPNeeded:=25000;
      end;
    end;
    'T' : begin
      case Char.Level of
      1 : XPNeeded:=120;
      2 : XPNeeded:=240;
      3 : XPNeeded:=480;
      4 : XPNeeded:=960;
      5 : XPNeeded:=2000;
      6 : XPNeeded:=4000;
      7 : XPNeeded:=8000;
      8 : XPNeeded:=25000;
      end;
    end;
    'D' : begin
      case Char.Level of
      1 : XPNeeded:=220;
      2 : XPNeeded:=440;
      3 : XPNeeded:=880;
      4 : XPNeeded:=1760;
      5 : XPNeeded:=3500;
      6 : XPNeeded:=7000;
      7 : XPNeeded:=14000;
      8 : XPNeeded:=25000;
      end;
    end;
  end;

end;

Function Roll (i:integer) : Integer;
begin

     Roll:=Random(i)+1;
end;

Function MultiRoll(n,m:integer) : Integer;
begin
MultiRoll:=0;
for i3:= 1 to n do
MultiRoll:=Random(m)+1;
end;

Function HitBonus : Integer;
begin
  Case Char.Class of
  'F','D','E','H' : begin
     case Char.Level of
     1..3 : HitBonus:=1;
     4..6 : HitBonus:=3;
     7..9 : HitBonus:=6;
     10..12 : HitBonus:=8;
     13..15 : HitBonus:=10;
     end;
  end;
  'M' : begin
     case Char.Level of
     1..5 : HitBonus:=1;
     6..10 : HitBonus:=3;
     11..15 : HitBonus:=6;
     16..20 : HitBonus:=8;
     21..25 : HitBonus:=10;
     end;
  end;
  'C','T' : begin
     case Char.Level of
     1..4 : HitBonus:=1;
     5..8 : HitBonus:=3;
     9..12 : HitBonus:=6;
     13..16 : HitBonus:=8;
     17..20 : HitBonus:=10;
     end;
  end;

  end;
end;

Function XPBonus : Integer;
begin
     Case Char.Class of
     'F','D','H' : XPBonus:=Char.Level*Char.StrMod;
     'M' : XPBonus:=Char.Level*Char.IntelMod;
     'C' : XPBonus:=Char.Level*Char.WisMod;
     'T' : XPBonus:=Char.Level*Char.DexMod;
     'E' : XPBonus:=Char.Level*((Char.StrMod+Char.IntelMod) div 2);

     end;
end;

Procedure NotImplemented;
begin
     textcolor(red);
     writeln('That command is not yet implemented. Try using a later version of the game.');
     textcolor(white);
     ReadKey;
end;


Procedure CalculateStuff;
begin

{Set Armor Values}
if Char.Armor = 'Leather' then
begin
Char.AC:=13;
end
else
if Char.Armor = 'Chainmail' then
begin
Char.AC:=15;
end
else
if Char.Armor = 'Platemail' then
begin
Char.AC:=17;
end
else
begin
Char.AC:=11;
end;

{Do Shield}
if Char.Shield = 'Shield' then
Char.AC:=Char.AC+1;

{Set Weapon Values}
if Char.Weapon = 'Two-handed Sword' then
begin
Char.Damage:=10;
Char.DamageBonus:=0;
end
else
if Char.Weapon = 'Dagger' then
begin
Char.Damage:=4;
Char.DamageBonus:=0;
end
else
if Char.Weapon = 'Sword' then
begin
Char.Damage:=8;
Char.DamageBonus:=0;
end
else
if Char.Weapon = 'Mace' then
begin
Char.Damage:=6;
Char.DamageBonus:=0;
end
else
begin
Char.Damage:=2;
Char.DamageBonus:=0;
end;



{Calculate AC}
Char.AC:=Char.AC+Char.DexMod;

{Calculate Other Stuff}
case Char.Class of
'M','E' : Mana:=Char.Level;
'C' : Mana:=Char.Level-1;
'H','D','F','T' : Mana:=0;
end;
ACBonus:=0;
Char.HitBonus:=HitBonus;

end;

Procedure Statistics;
begin
     repeat
           {Roll Statistics}
           Char.Str:=Roll(6)+Roll(6)+Roll(6);
           Char.Intel:=Roll(6)+Roll(6)+Roll(6);
           Char.Wis:=Roll(6)+Roll(6)+Roll(6);
           Char.Dex:=Roll(6)+Roll(6)+Roll(6);
           Char.Con:=Roll(6)+Roll(6)+Roll(6);
           Char.Cha:=Roll(6)+Roll(6)+Roll(6);

           {Determine Modifiers}
           Char.StrMod:=DetermineStatMod(Char.Str);
           Char.IntelMod:=DetermineStatMod(Char.Intel);
           Char.WisMod:=DetermineStatMod(Char.Wis);
           Char.DexMod:=DetermineStatMod(Char.Dex);
           Char.ConMod:=DetermineStatMod(Char.Con);
           Char.ChaMod:=DetermineStatMod(Char.Cha);

           {Display Abilities}
           ClrScr;
           textcolor(yellow);
           writeln('Your character`s Ability Scores have been determined: ');
           writeln;
           textcolor(white);
           writeln('Ability       ','Score',     ' Modifier');
           writeln('Strength:     ',Char.Str,    '    ',Char.StrMod);
           writeln('Intelligence: ',Char.Intel,'    ',Char.IntelMod);
           writeln('Wisdom:       ',Char.Wis,      '    ',Char.WisMod);
           writeln('Dexterity:    ',Char.Dex,   '    ',Char.DexMod);
           writeln('Constitution: ',Char.Con,'    ',Char.ConMod);
           writeln('Charisma:     ',Char.Cha,    '    ',Char.ChaMod);
           writeln;
           textcolor(yellow);

           {Confirmation of Scores}
           writeln('Do you wish to regenerate scores? (y/n) - ');
           Key:=ReadKey;
           Key:=UpCase(Key);
     until Key in ['N'];

end;

Procedure ChooseClass;
begin
     {Present Classes}
     textcolor(yellow);
     writeln('You must choose one of the following classes - ');
     textcolor(white);
     writeln('(c) Cleric (beta)');
     writeln('(f) Fighter');
     writeln('(m) Magic User (beta)');
     writeln('(t) Thief (beta)');
     writeln('(d) Dwarf (beta)');
     writeln('(e) Elf (beta)');
     writeln('(h) Halfling (beta)');

     {Wait for choice of Class}
     repeat
           Char.Class:=ReadKey;
           Char.Class:=UpCase(Char.Class);
     until Char.Class in ['F','M','C','H','E','D','T'];

     {Determine Name of Class for future use}

     Case Char.Class of
     'F' : Char.ClassName:='Fighter';
     'M' : Char.ClassName:='Magic User';
     'C' : Char.ClassName:='Cleric';
     'T' : Char.ClassName:='Thief';
     'E' : Char.ClassName:='Elf';
     'H' : Char.ClassName:='Halfling';
     'D' : Char.ClassName:='Dwarf';

     end;

     {Display Name of Chosen Class}

     writeln;
     textcolor(yellow); writeln('You have chosen to be a ',Char.ClassName);
     textcolor(cyan); writeln('Press any key to continue');

     ReadKey;

end;

Procedure FinishDetails;
begin
     {Determine Class Related Attributes}

     Case Char.Class of
     'F','D' : begin;
     Char.MaxHP:=8+Char.ConMod;
     end;
     'M','T' : begin
     Char.MaxHP:=4+Char.ConMod;
     end;
     'C','H','E' : begin
     Char.MaxHP:=6+Char.ConMod;
     end;
     end;

     {Fill in universal beginning stats}
     Char.GP:=(Roll(6)+Roll(6)+Roll(6))*10;
     Char.XP:=0;
     Char.Level:=1;
     Char.AC:=10+Char.DexMod;
     Char.CurHP:=Char.MaxHP;
     Char.HitBonus:=1;

     {Present final statistics and ask for name}
     ClrScr;

     textcolor(yellow);
     writeln('Your final starting character details have been created.');
     textcolor(white);
     writeln('Starting Gold - ',Char.GP,' GP');
     writeln('Starting Experience - ',Char.XP,' XP');
     writeln('Starting Hit Points - ',Char.MaxHP,' HP');
     writeln('Starting Level - ',Char.Level);
     writeln('Hit Bonus - ',Char.HitBonus);
     writeln('Prime Requisite Bonus - ',XPBonus);
     writeln;
     textcolor(yellow);
     write('What do you wish to call your character? - ');
     readln(Char.Name);

end;

Procedure SaveChar;
begin
     ClrScr;
     TextColor(white);
     writeln('Saving Character ... ',Char.Name);
     assign(CharFile, Char.Name + '.csf');
     rewrite(CharFile);
     write(CharFile, Char);
     close(CharFile);
     delay(500);
     writeln(Char.Name,' Saved.');
     textcolor(yellow);
     writeln('Press any key to continue.');
     ReadKey;
end;

Procedure LoadChar; forward;

Procedure CreateNewChar;
begin
Statistics;
ChooseClass;
FinishDetails;
SaveChar;
LoadChar;
end;

Procedure LoadChar;
begin
     textcolor(yellow);
     write('Type the name of your character - ');
     readln(Temp);
     assign(CharFile, Temp +'.csf');
     {$I-}
     reset(CharFile);
     {$I+}
     i:=IOResult;
     if i <> 0 then
        begin
             ClrScr; textcolor(red);
             writeln('Error Reading File... There is no saved character of that name');
             writeln('Create a character with that name and try again.');
             ReadKey;
             halt;
        end;

     {$I-}
     read(CharFile, Char);
     {$I+}
     i:=IOResult;
     if i <> 0 then
        begin
             ClrScr;
             textcolor(red);
             writeln('Version Conflict: The character you are loading is too old.');
             writeln('You must create a new character.');
             ReadKey;
             halt;
        end;
     close(CharFile);
     textcolor(white);
     writeln('Character load complete.')
end;

Procedure OpenOrNew;
begin
     textcolor(yellow);
     writeln;
     writeln('Do you wish to load a previously created character? (y/n) -');
     writeln;
     textcolor(white);
     repeat
           Key:=ReadKey;
           Key:=UpCase(Key);
     until Key in ['Y','N'];

     Case Key of
     'Y' : LoadChar;
     'N' : CreateNewChar;
     end;
end;

Procedure Welcome;
begin
     repeat
     ClrScr;
     textcolor(yellow);
     GotoXY(25,13);
     write('Welcome to ');
     textcolor(Roll(15)); write('K');
     textcolor(Roll(15)); write('i');
     textcolor(Roll(15)); write('l');
     textcolor(Roll(15)); write('l ');
     textcolor(Roll(15)); write('D');
     textcolor(Roll(15)); write('a ');
     textcolor(Roll(15)); write('M');
     textcolor(Roll(15)); write('o');
     textcolor(Roll(15)); write('n');
     textcolor(Roll(15)); write('s');
     textcolor(Roll(15)); write('t');
     textcolor(Roll(15)); write('e');
     textcolor(Roll(15)); write('r');
     textcolor(Roll(15)); write('s ');
     textcolor(Roll(15)); write('G');
     textcolor(Roll(15)); write('a');
     textcolor(Roll(15)); write('m');
     textcolor(Roll(15)); write('e');

     textcolor(white);
     GotoXY(1,25);
     write('v. 0.45 (beta) -dont laugh (and if u just did *tsk* *tsk*');
     sound(Roll(1800)+200);
     delay(200);
     NoSound;
     until KeyPressed;

     ReadKey;
     ClrScr;
end;

Procedure GameHud;
begin
     textcolor(yellow);
     write('<',Char.CurHP,'/',Char.MaxHP,' HP, ',Char.XP,'/',XPNeeded,' XP, ',Char.GP,' GP>');
     textcolor(white);
end;

Procedure DeleteChar;
begin
    repeat
    Writeln;
    Writeln;
    Write('Do you want to save your current character first? [y/n] - ');
    Key := ReadKey;
    Key := UpCase(Key);
    until Key in ['Y','N'];

IF Key = 'Y' then SaveChar;

    repeat
    clrscr;
    Write('Type in the name of the character you wish to delete - ');
    readln(temp);
    until temp <> '';

    Writeln('Locating file...');
    Assign(CharFile, temp+'.csf');
    Writeln('Deleting Character file...');
    Reset(CharFile);
    Erase(CharFile);
    Writeln('Delete Sucessful!');
    Close(CharFile);
    ReadKey;

    LoadChar;

end;

Procedure DisplayStats;
begin
     CalculateStuff;
     textcolor(yellow);
     writeln('Your current statistics');
     textcolor(cyan);
     writeln('Level ',Char.Level,' ',Char.ClassName);
     textcolor(lightgray);
     writeln('Ability Score Mod');
     textcolor(white);
     writeln('Str:    ',Char.Str,'     ',Char.StrMod);
     writeln('Int:    ',Char.Intel,'     ',Char.IntelMod);
     writeln('Wis:    ',Char.Wis,'     ',Char.WisMod);
     writeln('Dex:    ',Char.Dex,'     ',Char.DexMod);
     writeln('Con:    ',Char.Con,'     ',Char.ConMod);
     writeln('Cha:    ',Char.Cha,'     ',Char.ChaMod);
     textcolor(lightgray);
     writeln('Other Details');
     textcolor(white);
     writeln('Weapon: ',Char.Weapon,', Hit Bonus: ',Char.HitBonus+Char.StrMod,', Damage: 1-',Char.Damage,'+',
     Char.DamageBonus+Char.StrMod);
     writeln('AC: ',Char.AC,', (Armor : ',Char.Armor,', ',Char.Shield,')');
     writeln('XP Bonus: ',XPBonus);
end;

Procedure GenerateEncounter;
begin
i:=Roll(4);
     If Char.Level = 1 then
        begin
          Case i of
          1 : begin
               Mon.Name:='Goblin';
               Mon.HP :=4;
               Mon.AC :=14;
               Mon.Hit :=1;
               Mon.Damage :=6;
               Mon.BonusDamage :=0;
               Mon.XP :=10;
               Mon.GP :=3;
               end;
          2 : begin
               Mon.Name:='Giant Rat';
               Mon.HP :=2;
               Mon.AC :=13;
               Mon.Hit :=1;
               Mon.Damage :=3;
               Mon.BonusDamage :=0;
               Mon.XP :=4;
               Mon.GP :=1;
               end;
          3 : begin
               Mon.Name:='Skeleton';
               Mon.HP :=5;
               Mon.AC :=13;
               Mon.Hit :=1;
               Mon.Damage :=8;
               Mon.BonusDamage :=0;
               Mon.XP :=10;
               Mon.GP :=1;
               end;
          4 : begin
               Mon.Name:='Green Slime';
               Mon.HP :=10;
               Mon.AC :=6;
               Mon.Hit :=1;
               Mon.Damage :=4;
               Mon.BonusDamage :=0;
               Mon.XP :=6;
               Mon.GP :=0;
               end;
          end;
        end
     else
     If Char.Level = 2 then
        begin
          Case i of
          1 : begin
               Mon.Name:='Gnoll';
               Mon.HP :=10;
               Mon.AC :=14;
               Mon.Hit :=2;
               Mon.Damage :=8;
               Mon.BonusDamage :=1;
               Mon.XP :=20;
               Mon.GP :=5;
               end;
          2 : begin
               Mon.Name:='Wolf';
               Mon.HP :=10;
               Mon.AC :=14;
               Mon.Hit :=2;
               Mon.Damage :=6;
               Mon.BonusDamage :=0;
               Mon.XP :=20;
               Mon.GP :=2;
               end;
          3 : begin
               Mon.Name:='Zombie';
               Mon.HP :=12;
               Mon.AC :=12;
               Mon.Hit :=2;
               Mon.Damage :=8;
               Mon.BonusDamage :=0;
               Mon.XP :=24;
               Mon.GP :=3;
               end;
          4 : begin
               Mon.Name:='Shadow';
               Mon.HP :=10;
               Mon.AC :=16;
               Mon.Hit :=2;
               Mon.Damage :=8;
               Mon.BonusDamage :=0;
               Mon.XP :=28;
               Mon.GP :=5;
               end;
          end;
        end
        else
     If Char.Level = 3 then
        begin
          Case i of
          1 : begin
               Mon.Name:='Sahuagin';
               Mon.HP :=15;
               Mon.AC :=15;
               Mon.Hit :=3;
               Mon.Damage :=8;
               Mon.BonusDamage :=1;
               Mon.XP :=30;
               Mon.GP :=6;
               end;
          2 : begin
               Mon.Name:='Baboon';
               Mon.HP :=15;
               Mon.AC :=14;
               Mon.Hit :=3;
               Mon.Damage :=6;
               Mon.BonusDamage :=0;
               Mon.XP :=24;
               Mon.GP :=3;
               end;
          3 : begin
               Mon.Name:='Wight';
               Mon.HP :=15;
               Mon.AC :=16;
               Mon.Hit :=3;
               Mon.Damage :=10;
               Mon.BonusDamage :=0;
               Mon.XP :=39;
               Mon.GP :=6;
               end;
          4 : begin
               Mon.Name:='Mephit';
               Mon.HP :=15;
               Mon.AC :=15;
               Mon.Hit :=3;
               Mon.Damage :=10;
               Mon.BonusDamage :=2;
               Mon.XP :=42;
               Mon.GP :=6;
               end;
          end;
        end
        else
     If Char.Level = 4 then
        begin
          Case i of
          1 : begin
               Mon.Name:='Ogre';
               Mon.HP :=24;
               Mon.AC :=15;
               Mon.Hit :=5;
               Mon.Damage :=10;
               Mon.BonusDamage :=2;
               Mon.XP :=55;
               Mon.GP :=10;
               end;
          2 : begin
               Mon.Name:='Bear';
               Mon.HP :=20;
               Mon.AC :=13;
               Mon.Hit :=4;
               Mon.Damage :=8;
               Mon.BonusDamage :=0;
               Mon.XP :=40;
               Mon.GP :=0;
               end;
          3 : begin
               Mon.Name:='Wraith';
               Mon.HP :=20;
               Mon.AC :=19;
               Mon.Hit :=4;
               Mon.Damage :=6;
               Mon.BonusDamage :=6;
               Mon.XP :=55;
               Mon.GP :=10;
               end;
          4 : begin
               Mon.Name:='Cube';
               Mon.HP :=20;
               Mon.AC :=13;
               Mon.Hit :=7;
               Mon.Damage :=7;
               Mon.BonusDamage :=1;
               Mon.XP :=50;
               Mon.GP :=5;
               end;
          end;
        end
        else
     If Char.Level = 5 then
        begin
          Case i of
          1 : begin
               Mon.Name:='Owlbear';
               Mon.HP :=30;
               Mon.AC :=14;
               Mon.Hit :=5;
               Mon.Damage :=13;
               Mon.BonusDamage :=3;
               Mon.XP :=60;
               Mon.GP :=8;
               end;
          2 : begin
               Mon.Name:='Small Elemental';
               Mon.HP :=25;
               Mon.AC :=17;
               Mon.Hit :=5;
               Mon.Damage :=11;
               Mon.BonusDamage :=1;
               Mon.XP :=60;
               Mon.GP :=8;
               end;
          3 : begin
               Mon.Name:='Ghost';
               Mon.HP :=25;
               Mon.AC :=19;
               Mon.Hit :=7;
               Mon.Damage :=12;
               Mon.BonusDamage :=0;
               Mon.XP :=80;
               Mon.GP :=0;
               end;
          4 : begin
               Mon.Name:='Wyvern';
               Mon.HP :=30;
               Mon.AC :=17;
               Mon.Hit :=5;
               Mon.Damage :=16;
               Mon.BonusDamage :=4;
               Mon.XP :=80;
               Mon.GP :=15;
               end;
          end;
        end
end;

Procedure ShowSlots;
begin
     textcolor(white);
     writeln('Slot 1 : ',Char.Equip1);
     writeln('Slot 2 : ',Char.Equip2);
     writeln('Slot 3 : ',Char.Equip3);
end;

Procedure UseItem;
begin
     Done:=True;

     ShowSlots;
     textcolor(yellow);
     writeln('Use item from which slot?');
     repeat
           Key:=ReadKey;
           Key:=UpCase(Key);
     until Key in ['1','2','3'];

     Case Key of
     '1' : temp:=Char.Equip1;
     '2' : temp:=Char.Equip2;
     '3' : temp:=Char.Equip3;
     end;

     if (temp = 'Healing Potion') then
     begin
          textcolor(white);
          i:=Roll(6)+1;
          Char.CurHP:=Char.CurHP+i;
          if Char.CurHP > Char.MaxHP then
          Char.CurHP:=Char.MaxHP;

          writeln('You drink the Potion and regained ',i,' HP.');

     end
     else
     begin
     textcolor(red);
     writeln('That item cannot be used.');
     Done:=False;
     end;
     If Done then
     begin
     Case Key of
     '1' : Char.Equip1:='';
     '2' : Char.Equip2:='';
     '3' : Char.Equip3:='';
     end;
     end;

end;

Procedure MonGo;
begin
{Monster Swing}
           hit:=Roll(20)+Mon.Hit;
           if hit >= Char.AC then
              begin
              dam:=Roll(Mon.Damage)+Mon.BonusDamage;
              Char.CurHP:=Char.CurHP-dam;
              textcolor(white);
              writeln('The ',Mon.Name,' hits (',hit,') you for ',dam,' damage. Ouch! You have, ',Char.CurHP,' HP left.');

              end
           else
               begin
               writeln('The ',Mon.Name,' tries to hit (',hit,') but misses you. Lucky!');
               end;
end;

Procedure PlayerGo;
begin
end;

Procedure Arcane;
begin
Done:=True;
       case Key of
       'A' : begin
         i:=Char.Level div 5+1;
         writeln('You cast Magic Missile. ',i,
         ' Magical bolt(s) fly toward the ',Mon.Name,'.');
         dam:=0;
         for i2:=1 to i do
         dam:=dam+Roll(6)+1;
         Mon.HP:=Mon.HP-dam;
         writeln('The ',Mon.Name,' takes ',dam,' damage.');
         end;
       'B' : begin
         i:=(250 div Mon.HP);
         writeln('You cast Sleep, with a ',i,
         '% chance to incapacitate the ',Mon.Name,'.');
            if Roll(100) <= i then
            begin
            Mon.HP:=0;
            textcolor(white);
            writeln('The ',Mon.Name,' was incapacited');
            end
            else
            begin
            writeln('The spell failed');
            end
         end;
       'C' : begin
         writeln('You cast Shield, giving you a base armor bonus of +7');
         Char.AC:=18+Char.DexMod+ACBonus;
         writeln('Your AC is now ',Char.AC);
         end;
       'D' : begin
         writeln('You cast Invisibility, giving you an advantage in combat. This grants +4 to hit, and +4 to your AC');
         ACBonus:=ACBonus+4;
         Char.AC:=Char.AC+ACBonus;
         writeln('Your AC is now ',Char.AC);
         end;
       'E' : begin
         i:=(500 div Mon.HP);
         writeln('You cast Phantasm, creating an illusion to fool your opponent.');
         if Roll(100) <= i then
         begin
         Mon.HP:=0;
         textcolor(white);
         writeln('The ',Mon.Name,' was fooled by the illusion and incapacitated.');
         end
         else
         begin
         Mon.Hit:=Mon.Hit-4;
         dam:=Roll(10);
         Mon.HP:=Mon.HP-dam;
         writeln('The ',Mon.Name,' was confused by the illusion, penalised -4 to hit, and took ',dam,' imaginary damage.');
         end
         end;
       end;
end;

Procedure Clerical;
begin
Done:=True;
       case Key of
       'A' : begin
         i:=Roll(6)+1;
         writeln('You cast Cure Light Wounds.');
         Char.CurHP:=Char.CurHP+i;
         if Char.CurHP > Char.MaxHP then
          Char.CurHP:=Char.MaxHP;
         writeln('You are healed ',i,' HP. You now have ',Char.CurHP,' HP.');
         end;
       'B' : begin
         writeln('You cast Protection from Evil. Your AC increases by 2.');
            Char.AC:=Char.AC+2;
            textcolor(white);
            writeln('Your AC is now ',Char.AC,'.');
         end;
       'C' : begin
         writeln('You cast Bless, giving a +1 bonus to hit and damage.');
         Char.HitBonus:=Char.HitBonus+1;
         Char.DamageBonus:=Char.DamageBonus+1;
         writeln('Your Hit Bonus is now +',Char.HitBonus+Char.StrMod,'.');
         end;
       'D' : begin
         i:=500 div Mon.HP;
         writeln('You cast Hold Creature, There is a ',i,'% chance your opponent is held immobilised.');
         if Roll(100)<=i then
          begin
          writeln('The opponent has been immobilised');
          Mon.HP:=0;
          end
          else
          begin
          writeln('The spell failed.');
          end
         end;
       'E' : begin
         writeln('You cast Cure Serious Wounds, which heals between 5 and 20 hp.');
         i:=MultiRoll(3,6)+2;
         Char.CurHP:=Char.CurHP+i;
         writeln('You regain ',i,' HP, you now have ',Char.CurHP,' HP left.');
         end;
       end;
end;

Procedure Spell;
begin
Done:=False;

case Char.Class of
'M','E' : begin
   textcolor(cyan);
   writeln('You are a arcane spell caster (elf/mage)');
   textcolor(lightgray);
   writeln('## Spell Name    Lvl Effect');
   textcolor(white);   
   writeln('a  Magic Missile  1  2-7 damage/5 levels');
   writeln('b  Sleep          1  Chance of knocking out monster');
   writeln('c  Shield         1  Grants armor bonus of +7 till end of fight');
   writeln('d  Invisibility   2  Gives +4 to hit, and +4 to AC for fight');
   writeln('e  Phantasm       2  Deals damage, gives monster -4 to hit and can knock out');

   textcolor(yellow);
   writeln('Select a Spell or (q)uit:');
   textcolor(white);
   repeat
     Key:=ReadKey;
     Key:=UpCase(Key);
   until Key in ['A','B','C','D','E','Q'];

   if ((Key='A') or (Key='B') or (Key='C')) and (Mana >=1) and (Char.Level >=1) then
   begin
   Mana:=Mana-1;
   Arcane;
   end
   else
   if ((Key='D') or (Key='E')) and (Mana >=2) and (Char.Level >=3) then
   begin
   Mana:=Mana-2;
   Arcane;
   end
   else
   if (Key='Q') then
   begin
   textcolor(red);
   writeln('Spellcasting cancelled');
   textcolor(white);
   end
   else
   begin
   textcolor(red);
   writeln('You do not have enough Mana to cast the selected spell or you are not of a high enough level.');
   end

end;

'C' : begin
   textcolor(cyan);
   writeln('You are a clerical spell caster (clerics only)');
   textcolor(lightgray);
   writeln('## Spell Name           Lvl Effect');
   textcolor(white);   
   writeln('a  Cure Light Wounds    1  Heals 2-7 hp');
   writeln('b  Protection from Evil 1  Grants +2 AC');
   writeln('c  Bless                1  Gives +1 to hit, +1 damage');
   writeln('d  Hold Creature        2  Chance of incapitating monster');
   writeln('e  Cure Serious Wounds  3  Heals 3-18 hp');

   textcolor(yellow);
   writeln('Select a Spell or (q)uit:');
   textcolor(white);
   repeat
     Key:=ReadKey;
     Key:=UpCase(Key);
   until Key in ['A','B','C','D','E','Q'];

   if ((Key='A') or (Key='B') or (Key='C')) and (Mana >=1) and (Char.Level >=2) then
   begin
   Mana:=Mana-1;
   Clerical;
   end
   else
   if ((Key='D')) and (Mana >=2) and (Char.Level >=4) then
   begin
   Mana:=Mana-2;
   Clerical;
   end
   else
   if ((Key='E')) and (Mana >=3) and (Char.Level >=6) then
   begin
   Mana:=Mana-3;
   Clerical;
   end
   else
   if (Key='Q') then
   begin
   textcolor(red);
   writeln('Spellcasting cancelled');
   textcolor(white);
   end
   else
   begin
   textcolor(red);
   writeln('You do not have enough Mana to cast the selected spell or you are not of a high enough level.');
   end
end;
end;


end;

Procedure Fight;
begin
     CalculateStuff;
     GenerateEncounter;
     textcolor(white);
     writeln('You are fighting a ',Mon.Name);
     ReadKey;
     repeat
        if Char.CurHP >0 then
         begin
          repeat
           textcolor(yellow);
           writeln(Char.CurHP,'/',Char.MaxHP,' HP | Combat Console: (h)it (s)pell (i)tem (f)lee ');
           textcolor(white);
             repeat
                   Key:=ReadKey;
                   Key:=UpCase(Key);
             until Key in ['H','S','I','F',' '];
             textcolor(white);
             case Key of
             'H',' ' : begin
                   {Player Swing}
                   hit:=Roll(20)+Char.StrMod+Char.HitBonus;
                   if hit >= Mon.AC then
                   begin
                   dam:=Roll(Char.Damage)+Char.StrMod+Char.DamageBonus;
                   Mon.HP:=Mon.HP-dam;
                   writeln('You hit (',hit,') the ',Mon.Name,' for ',dam,' damage.');
                   end
                   else
                   begin
                   writeln('You swing, (',hit,') but unfortunately miss the ',Mon.Name);
                   end;
                   Done:=True;
                   end;
             'S' : begin
                     case Char.Class of
                     'E','C','M' : Spell;
                     else
                     begin
                     textcolor(red);
                     writeln('Your chosen class does not have the ability to cast spells.');
                     end;
                     end;
                   end;
             'I' : begin
                   UseItem;
                   end;
             'F' : begin
                   textcolor(white);
                   writeln('You run away, the monster gets a free go');
                   MonGo;
                   exit;
                   end;
             end;






          until Done;

           ReadKey;
         end;
        if Mon.HP > 0 then
          begin
           MonGo;
          end;


     until (Mon.HP <=0) or (Char.CurHP <=0);

     if Char.CurHP <=0 then
        begin
        textcolor(red);
        writeln(Char.Name,' has died! You must start again.');
        OpenOrNew;
        end
     else
     if Mon.HP<=0 then
        begin
        textcolor(green);
        writeln('The ',Mon.Name,' is dead! You gain ',Mon.XP,' XP (+',
        XPBonus,' for PR value) and ',Mon.GP,' GP!');
        Char.XP:=Char.XP+Mon.XP+(XPBonus);
        Char.GP:=Char.GP+Mon.GP;
        end;


end;

Procedure Inventory;
begin
     textcolor(cyan);
     writeln('Inventory:');
     textcolor(white);
     writeln('Armor -',Char.Armor);
     writeln('Shield-',Char.Shield);
     writeln('Weapon-',Char.Weapon);
     writeln('Slot 1-',Char.Equip1);
     writeln('Slot 2-',Char.Equip2);
     writeln('Slot 3-',Char.Equip3);

end;

Procedure HelpMenu;
begin

repeat
     textcolor(cyan);
     writeln('The Help Console');
     textcolor(white);
     writeln('(1) General Play');
     writeln('(2) Commands');
     writeln('(3) Inventory and Statistics');
     writeln('(4) Fighting');
     textcolor(yellow);
     writeln('Do you want to view one of the above Help messages or (q)uit back to the game?');
     repeat
           Key:=ReadKey;
           Key:=UpCase(Key);
     until Key in ['1','2','3','4','Q'];



     Case Key of
     '1' : begin
         textcolor(lightgray);
writeln('General Play:');
textcolor(white);
writeln('Kill Da Monsters Game (KDMG) is a game developed by me :) in which');
writeln('the player creates a "character", that is an imaginary being with');
writeln('which to fight the many malevolent denizens of the game. As the');
writeln('character develops it will gain skills pertaining to the class.');
writeln('The normal game sequence is typing commands at the prompt to');
writeln('acheive things such as buying new equipment, and fighting another');
writeln('monster to putting stuff on and using items.');
     end;
     '2' : begin
     end;
     '3' : begin
     end;
     '4' : begin
     end;
     end;

until Key in ['Q'];

end;

Procedure Shops;
begin
     textcolor(cyan);
     writeln('Welcome to the Shops');
     Inventory;
     textcolor(yellow);
     writeln('Do you wish to (b)uy, (s)ell, or (l)eave the shops?');
  repeat
     repeat
           Key:=ReadKey;
           Key:=UpCase(Key);
     until Key in ['B','S','L'];



     if Key = 'B' then
        begin
        if (Char.Equip1 <> '') and (Char.Equip1 <> '') and (Char.Equip3 <> '') then
           begin
           textcolor(red);
           writeln('You are unable to buy, as your backpack is full');
           end
           else
           begin
           textcolor(yellow);
           writeln('You have chosen to Buy');
           textcolor(lightgray);
           writeln('# Item             Slot   Cost   NotFor Effect');
           textcolor(white);
           writeln('1 Sword            Weapon 10  GP CM     1-8 damage');
           writeln('2 Mace             Weapon 5   GP M      1-6 damage');
           writeln('3 Leather          Armor  5   GP M      AC 7');
           writeln('4 Chainmail        Armor  75  GP TM     AC 5');
           writeln('5 Platemail        Armor  400 GP TM     AC 3');
           writeln('6 Shield           Shield 10  GP TM     AC 1*');
           writeln('7 Healing Potion   Potion 5   GP na     Heals 2-7 HP');
           writeln('8 Dagger           Weapon 3   GP C      1-4 damage');
           writeln('9 Two-handed Sword Weapon 50  GP CTMHD  1-10 damage');
           textcolor(yellow);
           writeln('Press the number of the item you wish to buy, or (l) to leave the shops');
           textcolor(white);
           writeln('You currently have ',Char.GP,' GP');
           repeat
              Key:=ReadKey;
              Key:=UpCase(Key);
           until Key in ['1'..'9','L'];
              Case Key of
              '1' : begin
                  temp:='Sword'; i:=10; end;
              '2' : begin
                  temp:='Mace'; i:=5; end;
              '3' : begin
                  temp:='Leather'; i:=5; end;
              '4' : begin
                  temp:='Chainmail'; i:=75; end;
              '5' : begin
                  temp:='Platemail'; i:=400; end;
              '6' : begin
                  temp:='Shield'; i:=10; end;
              'L' : begin
                  exit; end;
              '7' : begin
                  temp:='Healing Potion'; i:=5; end;
              '8' : begin
                  temp:='Dagger'; i:=3; end;
              '9' : begin
                  temp:='Two-handed Sword'; i:=50; end;
              end;

           if Char.GP-i < 0 then
           begin
           textcolor(red);
           writeln('You do not have enough gold to purchase that item');
           exit;
           end;


           writeln('Are you sure you wish to buy ',temp,' for ',i,' GP? (Y/N)');

           repeat
              Key:=ReadKey;
              Key:=UpCase(Key);
           until Key in ['Y','N'];
           If Key = 'N' then begin
             end
             else

           If Key = 'Y' then begin
              textcolor(yellow);
              writeln('Select an empty slot to place the item in (1, 2 or 3)');
              ShowSlots;

              repeat
                    Key:=ReadKey;
                    Key:=UpCase(Key);
              until Key in ['1','2','3'];

              textcolor(white);
              if (Key = '1') and (Char.Equip1 = '') then
              begin
              Char.Equip1:=temp;
              writeln('The ',temp,' was placed in Slot 1');
              Char.GP:=Char.GP-i;
              writeln(i,' GP was deducted from your hoard. You have ',Char.GP,' GP left.');
              end
              else
              if (Key = '2') and (Char.Equip2 = '') then
              begin
              Char.Equip2:=temp;
              writeln('The ',temp,' was placed in Slot 2');
              Char.GP:=Char.GP-i;
              writeln(i,' GP was deducted from your hoard. You have ',Char.GP,' GP left.');
              end
              else
              if (Key = '3') and (Char.Equip3 = '') then
              begin
              Char.Equip3:=temp;
              writeln('The ',temp,' was placed in Slot 3');
              Char.GP:=Char.GP-i;
              writeln(i,' GP was deducted from your hoard. You have ',Char.GP,' GP left.');

              end
              else
              begin
              textcolor(red);
              writeln('The slot you selected may already be filled.');
              end;
              end
           end
           end
           else
        if Key = 'S' then
           begin
           textcolor(red);
           writeln('Not implemented yet');

           end
           else
        if Key = 'L' then
        begin
        textcolor(yellow);
        writeln('You leave the shops.');
        end;
   if (Key <> 'L') then
   begin
   textcolor(yellow);
   writeln('Choose again, (b)uy, (s)ell or (l)eave');
   end;

   until Key in ['L'];
end;

Procedure LevelUp;
begin
        Char.Level:=Char.Level+1;
        case Char.Class of
        'M','T' : Char.MaxHP:=Char.MaxHP+Roll(4)+Char.ConMod;
        'C','E','H' : Char.MaxHP:=Char.MaxHP+Roll(6)+Char.ConMod;
        'D','F' : Char.MaxHP:=Char.MaxHP+Roll(8)+Char.ConMod;
        end;
        Char.HitBonus:=HitBonus;
        Char.CurHP:=Char.MaxHP;
        textcolor(yellow);
        writeln('You have gone up a level!');
end;

Procedure Equip;
begin
        Inventory;
        textcolor(yellow);
        writeln('Choose an item from a slot to equip (1, 2 or 3)');
        repeat
         Key:=ReadKey;
         Key:=UpCase(Key);
        until Key in ['1','2','3'];

        case Key of
             '1' : temp:=Char.Equip1;
             '2' : temp:=Char.Equip2;
             '3' : temp:=Char.Equip3;
        end;

   if (temp = '') then
      begin
           textcolor(red);
           writeln('There is no item in that slot');
      end
   else
   begin
   textcolor(yellow);
   writeln('Place in which slot?');
   textcolor(white);
   writeln('(a) Armor -',Char.Armor);
   writeln('(s) Shield-',Char.Shield);
   writeln('(w) Weapon-',Char.Weapon);
   repeat
         Key2:=ReadKey;
         Key2:=UpCase(Key2);
   until Key2 in ['A','S','W'];

   case Key2 of
   'A' : begin
       if ((temp='Leather') and (Char.Class <> 'M')) or ((temp='Chainmail')
         and (Char.Class <> 'M') and (Char.Class <> 'T'))
         or ((temp='Platemail') and (Char.Class <> 'M')
         and (Char.Class <> 'T')) then
          begin
          temp2:=Char.Armor;
          Char.Armor:=temp;
          Case Key of
          '1' : Char.Equip1:=temp2;
          '2' : Char.Equip2:=temp2;
          '3' : Char.Equip3:=temp2;
          end;
          end
       else
           begin
           textcolor(red);
           writeln('Incorrect Item type or incompatible with class');
           end
       end;
   'S' : begin
       if ((temp='Shield') and (Char.Class <> 'M') and
         (Char.Class <> 'T') and (Char.Weapon <> 'Two-handed Sword')) then
          begin
          temp2:=Char.Shield;
          Char.Shield:=temp;
          Case Key of
          '1' : Char.Equip1:=temp2;
          '2' : Char.Equip2:=temp2;
          '3' : Char.Equip3:=temp2;
          end;
          end
       else
           begin
           textcolor(red);
           writeln('Incorrect Item type or incompatible with class');
           end
       end;
   'W' : begin
       if ((temp='Sword') and (Char.Class <> 'M') and (Char.Class <> 'C'))
         or ((temp='Mace') and (Char.Class <> 'M')) or ((temp='Dagger')
         and (Char.Class <> 'C')) or ((temp='Two-handed Sword')
         and (Char.Class <> 'M') and (Char.Class <> 'C')
         and (Char.Class <> 'T') and (Char.Class <> 'H') and (Char.Class <> 'D') and (Char.Shield = '')) then
          begin
          temp2:=Char.Weapon;
          Char.Weapon:=temp;
          Case Key of
          '1' : Char.Equip1:=temp2;
          '2' : Char.Equip2:=temp2;
          '3' : Char.Equip3:=temp2;
          end;
          end
       else
           begin
           textcolor(red);
           writeln('Incorrect Item type or incompatible with class');
           end;
       end;
   end;
   end;
end;

begin
{Prepare Game Environment}
ClrScr;
Randomize;

{Get Character Attributes}
Welcome;
OpenOrNew;

{Notify of Game Start}
ClrScr;
textcolor(white);
writeln('Character Preparation Complete...');
textcolor(yellow);
writeln('Press any key to begin game...');


{Begin Gameplay}
repeat

if Char.XP >= XPNeeded then
  LevelUp;

GameHud;
readln(temp);

{Change Case of instruction}
for i := 1 to length(temp) do
temp[i] := UpCase(temp[i]);

{General Commands}
if (temp = 'H') or (temp = 'HELP') then

begin
     HelpMenu;
end

else

IF (temp = 'S') or (temp = 'SAV') or (temp = 'SAVE') then
begin
     SaveChar;
end

else

if (temp = 'EQ') or (temp='E') or (temp='EQUIP') then
begin
   Equip;
end

else

IF (temp = 'L') or (temp = 'LOA') or (temp = 'LOAD') then
begin
     repeat
           Write('Are you sure you want to load a new character [Y/N] ');
           Key := ReadKey;
           Key:=UpCase(Key);
     until Key in ['Y','N'];

     IF Key = 'Y' then
     begin
           repeat
           Writeln;
           Write('Do you want to save your current character first [Y/N] ');
           Key := ReadKey;
           Key := UpCase(Key);
           until Key in ['Y','N'];

           IF Key = 'Y' then
           begin
           SaveChar;
           end;
     end;
     LoadChar;
end

else

if (temp = 'D') or (temp = 'DR') or (temp = 'DRO') or (temp = 'DROP') then

begin
     temp:='';
     Inventory;
     textcolor(yellow);
     writeln('Which slot is the item you wish to drop in? 1/2/3 or (c)ancel');
       repeat
         Key:=ReadKey;
         Key:=UpCase(Key);
       until Key in ['1','2','3','C'];
     case Key of
       '1','2','3' : begin
         case Key of
         '1' : temp:=Char.Equip1;
         '2' : temp:=Char.Equip2;
         '3' : temp:=Char.Equip3;
         end;

         textcolor(yellow);
         writeln('Are you sure you wish to drop ',temp,' (y/n)?');
         repeat
           Key2:=ReadKey;
           Key2:=UpCase(Key2);
         until Key2 in ['Y','N'];

         if (temp <> '') and (Key2='Y') then
         begin
           case Key of
           '1' : Char.Equip1:='';
           '2' : Char.Equip2:='';
           '3' : Char.Equip3:='';
           end;
           textcolor(white);
           writeln('The ',temp,' was dropped.');
         end
         else
         begin
           textcolor(red);
           writeln('There is no item in that slot');
         end
       end;
       'C' : begin
       textcolor(red);
       writeln('Item drop cancelled.');
       end
     end;
end

else

IF (temp = 'DEL') or (temp = 'DELE') or
    (temp = 'DELET') or (temp = 'DELETE') then
begin
     repeat
           clrscr;
           Write('Are you sure that you want to Delete a character ? [Y/N] ');
           Key := ReadKey;
           Key := UpCase(Key);
     until Key in ['y','n','Y','N'];

     IF Key = 'Y' then DeleteChar;

end

else

If  (temp = 'F') or (temp = 'FI') or (temp = 'FIG') or (temp = 'FIGHT') or (temp = 'FIG') then
    begin
         Fight;
    end

else

IF  (temp = 'STA') or (temp = 'STAT') or
    (temp = 'STATS') or (temp = 'STATI') or
    (temp = 'STATIS') or (temp = 'STATIST') or
    (temp = 'STATISTI') or (temp = 'STATISTIC') or
    (temp = 'STATISTICS') then
    begin
      DisplayStats;
    end

else

if (temp = 'U') or (temp = 'ITEM') OR (TEMP = 'USE') OR (TEMP = 'USE ITEM') then
   begin
        UseItem;
   end

else

if (temp = 'S') or (temp = 'SHO') or (temp = 'SHOP') or (temp = 'SHOPS') then
   begin
        Shops;
   end

else

if (temp = 'I') OR (TEMP = 'INV') OR (TEMP = 'INVENTORY') THEN
   begin
        Inventory;
   end

{Exiting Sequence}
until (temp = 'Q') or (temp = 'QU') or
(temp = 'QUI') or (temp = 'QUIT');

      repeat
            Write('Are you sure that you want to quit? [Y/N] ');
            Key := ReadKey;
            Key := UpCase(Key);
      until Key in ['Y','N'];

      IF Key = 'Y' then
      begin
      halt;
      end
      else GameHUD;




ReadKey;
end.
