Program CharGen;
Uses Crt, Dos;

Type
   Armortype = Set of (None,Leather,Chainmail,Platemail);

    Character = Record
   Class : Char;
   ClassName : String;
   ClassMod : Integer;
   Str: Integer;
   Intel : Integer;
   Wis : Integer;
   Dex : Integer;
   Con : Integer;
   Cha : Integer;
   StrMod: Integer;
   IntelMod : Integer;
   WisMod : Integer;
   DexMod : Integer;
   ConMod : Integer;
   ChaMod : Integer;
   GP : Integer;
   XP : Longint;
   MaxHP : Integer;
   CurHP : Integer;
   Name : String[15];
   Level : Integer;
   AC : Integer;
   Weapon : String;
   Armor : String;
   Shield : String;
   Equip1 : String;
   Equip2 : String;
   Equip3 : String;
   Damage : Integer;
   DamageBonus : Integer;
   HitBonus : Integer;
   end;


Var
   i : Integer;
   i2 : Integer;
   i3 : Integer;
   Key : Char;
   Key2 : Char;
   Key3 : Char;
   Statistic : Integer;
   Modifier : Integer;
   CharFile : File of Character;
   Char : Character;
   Temp : String;
   Temp2 : String;
   Temp3 : String;
   MonName : String;
   MonHP : Integer;
   MonAC : Integer;
   MonHit : Integer;
   MonDamage : Integer;
   MonBonusDamage : Integer;
   MonXP : Integer;
   MonGP : Integer;
   hit : Integer;
   dam : Integer;
   ASet : Armortype;
   ArmorCheck : Armortype;
   Done : Boolean;




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

Function XPNeeded : Integer;
begin
     case Char.Level of
     1 : XPNeeded:=100;
     2 : XPNeeded:=300;
     3 : XPNeeded:=600;
     4 : XPNeeded:=1000;
     5 : XPNeeded:=1500;
     6 : XPNeeded:=2100;
     7 : XPNeeded:=2700;
     8 : XPNeeded:=3500;
     end;
end;

Function Roll (i:integer) : Integer;
begin

     Roll:=Random(i)+1;
end;

Function HitBonus : Integer;
begin
  Case Char.Class of
  'F' : begin
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
  end;
end;

Function XPBonus : Integer;
begin
     Case Char.Class of
     'F' : XPBonus:=Char.Level*Char.StrMod;
     'M' : XPBonus:=Char.Level*Char.IntelMod;
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
if Char.Weapon = 'Wavy Sword' then
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
     writeln('(c) Cleric (not available)');
     writeln('(f) Fighter');
     writeln('(m) Magic User (partial function)');
     writeln('(t) Thief (not available)');
     writeln('(d) Dwarf (not available)');
     writeln('(e) Elf (not available)');
     writeln('(h) Halfling (not available)');

     {Wait for choice of Class}
     repeat
           Char.Class:=ReadKey;
           Char.Class:=UpCase(Char.Class);
     until Char.Class in ['F','M'];

     {Determine Name of Class for future use}

     Case Char.Class of
     'F' : Char.ClassName:='Fighter';
     'M' : Char.ClassName:='Magic User'
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
     'F' : begin;
     Char.MaxHP:=8+Char.ConMod;
     Char.ClassMod:=Char.StrMod;
     end;
     'M' : begin
     Char.MaxHP:=4+Char.ConMod;
     Char.ClassMod:=Char.IntelMod;
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
     write('v. 0.24 (beta)');
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
               MonName:='Goblin';
               MonHP :=4;
               MonAC :=14;
               MonHit :=1;
               MonDamage :=6;
               MonBonusDamage :=0;
               MonXP :=10;
               MonGP :=1;
               end;
          2 : begin
               MonName:='Giant Rat';
               MonHP :=2;
               MonAC :=13;
               MonHit :=1;
               MonDamage :=3;
               MonBonusDamage :=0;
               MonXP :=4;
               MonGP :=0;
               end;
          3 : begin
               MonName:='Skeleton';
               MonHP :=5;
               MonAC :=13;
               MonHit :=1;
               MonDamage :=8;
               MonBonusDamage :=0;
               MonXP :=10;
               MonGP :=0;
               end;
          4 : begin
               MonName:='Green Slime';
               MonHP :=10;
               MonAC :=6;
               MonHit :=1;
               MonDamage :=4;
               MonBonusDamage :=0;
               MonXP :=6;
               MonGP :=0;
               end;
          end;
        end
     else
     If Char.Level = 2 then
        begin
          Case i of
          1 : begin
               MonName:='Gnoll';
               MonHP :=10;
               MonAC :=14;
               MonHit :=2;
               MonDamage :=8;
               MonBonusDamage :=1;
               MonXP :=20;
               MonGP :=3;
               end;
          2 : begin
               MonName:='Wolf';
               MonHP :=10;
               MonAC :=14;
               MonHit :=2;
               MonDamage :=6;
               MonBonusDamage :=0;
               MonXP :=20;
               MonGP :=0;
               end;
          3 : begin
               MonName:='Zombie';
               MonHP :=12;
               MonAC :=12;
               MonHit :=2;
               MonDamage :=8;
               MonBonusDamage :=0;
               MonXP :=24;
               MonGP :=0;
               end;
          4 : begin
               MonName:='Shadow';
               MonHP :=10;
               MonAC :=16;
               MonHit :=2;
               MonDamage :=8;
               MonBonusDamage :=0;
               MonXP :=28;
               MonGP :=0;
               end;
          end;
        end
        else
     If Char.Level = 3 then
        begin
          Case i of
          1 : begin
               MonName:='Sahuagin';
               MonHP :=15;
               MonAC :=15;
               MonHit :=3;
               MonDamage :=8;
               MonBonusDamage :=1;
               MonXP :=30;
               MonGP :=6;
               end;
          2 : begin
               MonName:='Baboon';
               MonHP :=15;
               MonAC :=14;
               MonHit :=3;
               MonDamage :=6;
               MonBonusDamage :=0;
               MonXP :=24;
               MonGP :=3;
               end;
          3 : begin
               MonName:='Wight';
               MonHP :=15;
               MonAC :=16;
               MonHit :=3;
               MonDamage :=10;
               MonBonusDamage :=0;
               MonXP :=39;
               MonGP :=6;
               end;
          4 : begin
               MonName:='Mephit';
               MonHP :=15;
               MonAC :=15;
               MonHit :=3;
               MonDamage :=10;
               MonBonusDamage :=2;
               MonXP :=42;
               MonGP :=6;
               end;
          end;
        end
        else
     If Char.Level = 4 then
        begin
          Case i of
          1 : begin
               MonName:='Ogre';
               MonHP :=24;
               MonAC :=15;
               MonHit :=5;
               MonDamage :=10;
               MonBonusDamage :=2;
               MonXP :=55;
               MonGP :=10;
               end;
          2 : begin
               MonName:='Bear';
               MonHP :=20;
               MonAC :=13;
               MonHit :=4;
               MonDamage :=8;
               MonBonusDamage :=0;
               MonXP :=40;
               MonGP :=0;
               end;
          3 : begin
               MonName:='Wraith';
               MonHP :=20;
               MonAC :=19;
               MonHit :=4;
               MonDamage :=6;
               MonBonusDamage :=6;
               MonXP :=55;
               MonGP :=10;
               end;
          4 : begin
               MonName:='Cube';
               MonHP :=20;
               MonAC :=13;
               MonHit :=7;
               MonDamage :=7;
               MonBonusDamage :=1;
               MonXP :=50;
               MonGP :=5;
               end;
          end;
        end
        else
     If Char.Level = 5 then
        begin
          Case i of
          1 : begin
               MonName:='Owlbear';
               MonHP :=30;
               MonAC :=14;
               MonHit :=5;
               MonDamage :=13;
               MonBonusDamage :=3;
               MonXP :=60;
               MonGP :=8;
               end;
          2 : begin
               MonName:='Small Elemental';
               MonHP :=25;
               MonAC :=17;
               MonHit :=5;
               MonDamage :=11;
               MonBonusDamage :=1;
               MonXP :=60;
               MonGP :=8;
               end;
          3 : begin
               MonName:='Ghost';
               MonHP :=25;
               MonAC :=19;
               MonHit :=7;
               MonDamage :=12;
               MonBonusDamage :=0;
               MonXP :=80;
               MonGP :=0;
               end;
          4 : begin
               MonName:='Wyvern';
               MonHP :=30;
               MonAC :=17;
               MonHit :=5;
               MonDamage :=16;
               MonBonusDamage :=4;
               MonXP :=80;
               MonGP :=15;
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
           hit:=Roll(20)+MonHit;
           if hit >= Char.AC then
              begin
              dam:=Roll(MonDamage)+MonBonusDamage;
              Char.CurHP:=Char.CurHP-dam;
              writeln('The ',MonName,' hits (',hit,') you for ',dam,' damage. Ouch! You have, ',Char.CurHP,' HP left.');

              end
           else
               begin
               writeln('The ',MonName,' tries to hit (',hit,') but misses you. Lucky!');
               end;
end;

Procedure PlayerGo;
begin
end;

Procedure Fight;
begin
     CalculateStuff;
     GenerateEncounter;
     textcolor(white);
     writeln('You are fighting a ',MonName);
     ReadKey;
     repeat
        if Char.CurHP >0 then
         begin
          repeat
           textcolor(yellow);
           writeln('Combat Console: (h)it (s)pell (i)tem (f)lee');
             repeat
                   Key:=ReadKey;
                   Key:=UpCase(Key);
             until Key in ['H','S','I','F',' '];
             textcolor(white);
             case Key of
             'H',' ' : begin
                   {Player Swing}
                   hit:=Roll(20)+Char.StrMod+Char.HitBonus;
                   if hit >= MonAC then
                   begin
                   dam:=Roll(Char.Damage)+Char.StrMod+Char.DamageBonus;
                   MonHP:=MonHP-dam;
                   writeln('You hit (',hit,') the ',MonName,' for ',dam,' damage.');
                   end
                   else
                   begin
                   writeln('You swing, (',hit,') but unfortunately miss the ',MonName);
                   end;
                   Done:=True;
                   end;
             'S' : begin
                   textcolor(red);
                   writeln('That command is not implemented yet.');
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
        if MonHP > 0 then
          begin
           MonGo;
          end;


     until (MonHP <=0) or (Char.CurHP <=0);

     if Char.CurHP <=0 then
        begin
        textcolor(red);
        writeln(Char.Name,' has died! You must start again.');
        OpenOrNew;
        end
     else
     if MonHP<=0 then
        begin
        textcolor(green);
        writeln('The ',MonName,' is dead! You gain ',MonXP,' XP (+',
        Char.Level*Char.ClassMod,' for PR value) and ',MonGP,' GP!');
        Char.XP:=Char.XP+MonXP+(Char.Level*Char.ClassMod);
        Char.GP:=Char.GP+MonGP;
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
           writeln('# Item           Slot   Cost   Effect');
           textcolor(white);
           writeln('1 Sword          Weapon 10  GP 1-8 damage');
           writeln('2 Mace           Weapon 5   GP 1-6 damage');
           writeln('3 Leather        Armor  5   GP AC 7');
           writeln('4 Chainmail      Armor  75  GP AC 5');
           writeln('5 Platemail      Armor  400 GP AC 3');
           writeln('6 Shield         Shield 10  GP AC 1*');
           writeln('7 Healing Potion Potion 5   GP Heals 2-7 HP');
           writeln('8 Dagger         Weapon 3   GP 1-4 damage');
           writeln('9 Wavy Sword     Weapon 200 GP 1-10 damage');
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
                  temp:='Wavy Sword'; i:=200; end;
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
           If Key = 'Y' then begin
              textcolor(yellow);
              writeln('Select an empty slot to place the item in (1, 2 or 3)');
              textcolor(white);
              writeln('Slot (1) ',Char.Equip1);
              writeln('Slot (2) ',Char.Equip2);
              writeln('Slot (3) ',Char.Equip3);

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
   begin
        Char.Level:=Char.Level+1;
        Char.MaxHP:=Char.MaxHP+Roll(8)+Char.ConMod;
        Char.HitBonus:=HitBonus;
        Char.CurHP:=Char.MaxHP;
        textcolor(yellow);
        writeln('You have gone up a level!');
   end;

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

IF (temp = 'SAV') or (temp = 'SAVE') then
begin
     SaveChar;
end

else

if (temp = 'EQ') or (temp='E') or (temp='EQUIP') then
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
       if (temp='Leather') or (temp='Chainmail') or (temp='Platemail') then
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
           writeln('Incorrect Item type');
           end
       end;
   'S' : begin
       if (temp='Shield') then
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
           writeln('Incorrect Item type');
           end
       end;
   'W' : begin
       if (temp='Sword')  or (temp='Mace') or (temp='Dagger') or (temp='Wavy Sword') then
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
           writeln('Incorrect Item type');
           end;
       end;
   end;

   end;

end

else

IF (temp = 'LOA') or (temp = 'LOAD') then
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

if (temp = 'ITEM') OR (TEMP = 'USE') OR (TEMP = 'USE ITEM') then
   begin
        UseItem;
   end

else

if (temp = 'SHO') or (temp = 'SHOP') or (temp = 'SHOPS') then
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
