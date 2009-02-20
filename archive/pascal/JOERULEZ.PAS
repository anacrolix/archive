Program JoeRulez;
Uses Crt, Dos;

Type
   TypeArmor = Set of (None, Leather, Chainmail, Platemail);

    Character = Record
   Class : Char;
   ClassName : String;
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
   Shield : Boolean;
   Equip1 : String;
   Equip2 : String;
   Equip3 : String;
   end;


Var
   i : Integer;
   Key : Char;
   Key2 : Char;
   Key3 : Char;
   Statistic : Integer;
   Modifier : Integer;
   CharFile : File of Character;
   Char : Character;
   Temp : String;
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
     writeln('(m) Magic User (not available)');
     writeln('(t) Thief (not available)');
     writeln('(d) Dwarf (not available)');
     writeln('(e) Elf (not available)');
     writeln('(h) Halfling (not available)');

     {Wait for choice of Class}
     repeat
           Char.Class:=ReadKey;
           Char.Class:=UpCase(Char.Class);
     until Char.Class in ['F'];

     {Determine Name of Class for future use}

     Case Char.Class of
     'F' : Char.ClassName:='Fighter'
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
     end;
     end;

     {Fill in universal beginning stats}
     Char.GP:=(Roll(6)+Roll(6)+Roll(6))*10;
     Char.XP:=0;
     Char.Level:=1;
     Char.AC:=10+Char.DexMod;
     Char.CurHP:=Char.MaxHP;

     {Present final statistics and ask for name}
     ClrScr;

     textcolor(yellow);
     writeln('Your final starting character details have been created.');
     textcolor(white);
     writeln('Starting Gold - ',Char.GP,' GP');
     writeln('Starting Experience - ',Char.XP,' XP');
     writeln('Starting Hit Points - ',Char.MaxHP,' HP');
     writeln('Starting Level - ',Char.Level);
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
     ClrScr;
     textcolor(yellow);
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
     textcolor(Roll(15)); write('C');
     textcolor(Roll(15)); write('h');
     textcolor(Roll(15)); write('a');
     textcolor(Roll(15)); write('r');
     textcolor(Roll(15)); write('a');
     textcolor(Roll(15)); write('c');
     textcolor(Roll(15)); write('t');
     textcolor(Roll(15)); write('e');
     textcolor(Roll(15)); write('r');
     textcolor(Roll(15)); write(' G');
     textcolor(Roll(15)); write('e');
     textcolor(Roll(15)); write('n');
     textcolor(Roll(15)); write('e');
     textcolor(Roll(15)); write('r');
     textcolor(Roll(15)); write('a');
     textcolor(Roll(15)); write('t');
     textcolor(Roll(15)); write('o');
     textcolor(Roll(15)); write('r');

     textcolor(white);
     GotoXY(1,25);
     write('v. 0.01 (beta)');
     sound(Roll(1800)+200);
     delay(200);
     NoSound;
     until KeyPressed;

     ReadKey;

end;

Procedure GameHud;
begin
     write('<',Char.CurHP,'/',Char.MaxHP,' HP, ',Char.XP,' XP, ',Char.GP,' GP>');
end;

Procedure DeleteChar;
begin
    repeat
    Writeln;
    Writeln;
    Write('Do you want to save your current character first? [Y/N] - ');
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
     GameHud;
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
               MonAC :=11;
               MonHit :=1;
               MonDamage :=6;
               MonBonusDamage :=0;
               MonXP :=5;
               MonGP :=2;
               end;
          2 : begin
               MonName:='Rat';
               MonHP :=2;
               MonAC :=11;
               MonHit :=1;
               MonDamage :=3;
               MonBonusDamage :=0;
               MonXP :=5;
               MonGP :=1;
               end;
          3 : begin
               MonName:='Skeleton';
               MonHP :=5;
               MonAC :=11;
               MonHit :=1;
               MonDamage :=8;
               MonBonusDamage :=0;
               MonXP :=10;
               MonGP :=0;
               end;
          4 : begin
               MonName:='Kobold';
               MonHP :=3;
               MonAC :=11;
               MonHit :=1;
               MonDamage :=4;
               MonBonusDamage :=0;
               MonXP :=5;
               MonGP :=1;
               end;
          end;
        end
end;

Procedure MonGo;
begin
end;

Procedure PlayerGo;
begin
end;

Procedure Fight;
begin
     GenerateEncounter;
     textcolor(white);
     writeln('You are fighting a ',MonName);
     delay(500);
     repeat
           {Player Swing}
           hit:=Roll(20)+Char.StrMod;

           if hit > MonAC then
              begin
              dam:=Roll(8)+Char.StrMod;
              MonHP:=MonHP-dam;
              writeln('You hit (',hit,') the ',MonName,' for ',dam,' damage.');
              end
           else
               begin
               writeln('You swing, but unfortunately miss the ',MonName);
               end;

           ReadKey;

           {Monster Swing}
           if Roll(20)+MonHit > Char.AC then
              begin
              dam:=Roll(MonDamage)+MonBonusDamage;
              Char.CurHP:=Char.CurHP-dam;
              writeln('The ',MonName,' hits you for ',dam,' damage. Ouch! You have, ',Char.CurHP,' HP left.');

              end
           else
               begin
               writeln('The ',MonName,' tries to hit but misses you. Lucky!');
               end;

           ReadKey;



     until (MonHP <=0) or (Char.CurHP <=0);

     if Char.CurHP <=0 then
        begin
        writeln(Char.Name,' has died! You must start again.');
        OpenOrNew;
        end
     else
     if MonHP<=0 then
        begin
        writeln('The ',MonName,' is dead! You gain ',MonXP,' XP and ',MonGP,' GP!');
        Char.XP:=Char.XP+MonXP;
        Char.GP:=Char.GP+MonGP;
        end;


end;


Procedure Inventory;
begin
     textcolor(cyan);
     writeln;
     writeln('Inventory:');
     textcolor(white);
     writeln('Weapon-',Char.Weapon);
     writeln('Armor -',Char.Armor);
     writeln('Shield-',Char.Shield);
     writeln('Slot 1-',Char.Equip1);
     writeln('Slot 2-',Char.Equip2);
     writeln('Slot 3-',Char.Equip3);
     writeln;
     textcolor(yellow);

end;

Procedure Shops;
begin
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

GameHud;
readln(temp);

{Change Case of instruction}
for i := 1 to length(temp) do
temp[i] := UpCase(temp[i]);

{General Commands}
IF (temp = 'SAV') or (temp = 'SAVE') then
begin
     SaveChar;
end

else

if (temp = 'EQ') or (temp='E') or (temp='EQUIP') then
   begin
   Inventory;

   {Choose Item to equip}
   textcolor(yellow);
   writeln('Choose an item from a slot to equip');
   textcolor(white);
   writeln('(1) Slot 1');
   writeln('(2) Slot 2');
   writeln('(3) Slot 3');
   repeat
         Key:=ReadKey;
         Key:=UpCase(Key);
   until Key in ['1','2','3'];
   case Key of
   '1' : temp:=Char.Equip1;
   '2' : temp:=Char.Equip2;
   '3' : temp:=Char.Equip3;

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

       if
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

If  (temp = 'FIGHT') or (temp = 'FIG') then
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
      GameHud;
    end

else

if (temp = 'SHOP') or (temp = 'SHOPS') then
   begin
        Shops;
        GameHud;
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
