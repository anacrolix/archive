Program Game1;
uses dos, crt;

Type

level = record {has types of each of the below}
  description:string[100]; {the description of the square}
  items:array[1..4] of boolean; {change the size of this array to get more items in the square}
  mobs:array[1..4] of shortint;  {change the size of this array to get more mobs in the square}
  walk:boolean; {true or false variable}
end;

Charac = record
  Ptype, Pname:string[20];
  str, dex, hp, arm, int, maxmass, maxinv, expgot, expneed:integer;
  nitems, witems, levelc, chp, mana, cmana:integer;
end;

Var
  mobchar:array [1..6] of string;
  h, m, s, d, hund, diff,x , y:word;
  time, comptime:longint;
  currentlevel:array [1..8,1..8] of level; {the first level, for others add e.g. level2:array[1..x,1..x] of level}
  mobname, items, skillx, name:string[20];
  SavedChar, Maincom, loadche:string[12];
  pre, SPT, Chartrue, nametrue, quitgame, trainagain, bora:char;
  f: text;
  z: file of charac;
  c: charac;
  count, tick:integer;
  helpchoose:char;
  newcheck:string;
  quithelp, suredel, syn :char;

Procedure Help;
begin
repeat
  textcolor(11);
  clrscr;
  writeln('You entered help...');
  writeln;
  Writeln('What do you want help on: (a)Training');
  writeln('                          (b)Command Screen');
  writeln('                          (c)Commands');
  writeln('                          (d)Real Time');
  writeln('                          (e)Items');
  writeln('                          (f)Weapons');
  writeln('                          (g)Mobs');
  writeln('                          (h)About');
  write('At any time type quit to exit out of help :  ');
  readln(helpchoose);
  helpchoose:=UPCASE(helpchoose);

   If helpchoose = 'A' then
 begin
    clrscr;
    writeln(' There is not much help on Training but that if you want to Train then');
    writeln('you need to quit and go to Training from there.');
    writeln;
    writeln('Press Enter to exit...');
    readln;
 end

   else

   If helpchoose = 'B' then
 begin
    clrscr;
    writeln(' There is not much to say about the command screen in the Beta');
    writeln('version as you may not do anything to it and it does not react');
    writeln('to anything you do.');
    writeln;
    writeln(' A real-timer has been inputed to the command line, everytime you hit');
    writeln('enter a number is displayed that is the real-timer.');
    writeln;
    writeln(' The only thing that you are able to know is that your command screen');
    writeln('is that the following items are your command line:');
    writeln('                           :Current Health [hp]');
    writeln('                           :Maximum Health [HP]');
    writeln('                           :Current Mana [m]');
    writeln('                           :Maximum Mana [M]');
    writeln('                           :Current Experience [C Exp]');
    writeln('                           :Needed Experience [N Exp');
    readln;
    writeln;
    writeln('                    An example of your HUD would be as shown.');
    Write('<',c.chp,'hp|',c.hp,'hp * ',c.cmana,'m|',c.mana,'M * ',c.expgot,' C Exp|',c.expneed,' N Exp>   :   ');
    writeln;
    writeln('Press Enter to exit...');
    readln;
    clrscr;
 end

   else

   If helpchoose = 'C' then
 begin
   clrscr;
   writeln(' If you are having trouble with spelling your word then do not worry');
   writeln('if you type in incorect word Amenc will try and figure out what you');
   writeln('were teying to type in the first place.');
   readln;
   clrscr;
   writeln(' The following words are the commands you may choose to use throughout');
   writeln('the game and their action:');
   readln;
   writeln(' Inventory : Accesses your inventory          Quit : Leaves the game');
   writeln(' Skills : Enters a list of your skills        Save : Quick saves your char');
   writeln(' Equipment : Accesses your list of equipment  Delete : Deletes current char');
   writeln(' New mob : Allows you to create a new mob     Help : Enters this zone');
   writeln(' Freinds : Opens your mob list');
   writeln(' Statistics : Accesses your statistics');
   writeln;
   writeln(' North : Moves player north                   South : Moves player south');
   writeln(' West : Moves player west                     East : Moves player east');
   writeln(' Down : Moves player down                     Up : Moves player up');
   writeln;
   writeln('Press Enter to exit...');
   readln;
 end

   else

    If helpchoose = 'D' then
 begin
   clrscr;
   writeln('This game is timed by the computer, this is the real-time clock.');
   writeln('It is diplayed in your command screen as a few digits.');
   writeln;
   writeln(' The computer counts this read-timer in how many seconds you have been');
   writeln('playing.');
   writeln;
   writeln('Press Enter to continue...');
   readln;
 end

   else

    If helpchoose = 'E' then
 begin
   clrscr;
   writeln('There is not much to say about items, items are strewn around the world.');
   writeln('Items can be weapons, pieces of clothing, or potions.');
   writeln;
   writeln(' If it is equipment that you are wearing it can upgrade you stats');
   writeln('depending on what the item is, eg. normal, magic, unique etc.');
   writeln;
   writeln(' If weapons, the weapon can also upgrade your stats in any way but');
   writeln('most weapons will upgrade your damage.');
   writeln;
   writeln('Press Enter to continue...');
   readln;
 end

   else

    If helpchoose = 'F' then
 begin
   clrscr;
   writeln('Weapons differ a great lot depending on what you are looking at.');
   writeln('An axe would do something a lot different to a bow, as the axe is a melee');
   writeln('weapon and the bow is a ranged weapon.');
   writeln;
   writeln('The main characteristic that you should be looking for in a weapon is');
   writeln('damage. You may not use a weapon for damage but for upgrading your stats,');
   writeln('eg. you can be a mage (in full version) that uses magic instead of using');
   writeln('another weapon.');
   writeln;
   writeln('Press Enter to continue...');
   readln;
 end

   else

    If helpchoose = 'G' then
 begin
   clrscr;
   writeln(' There is two types of mobs in this game but do not fret it easy to tell');
   writeln('between the two.');
   writeln;
   writeln('1> The most common mob you will see is an enemy, this is what they are');
   writeln('called throughout the game.');
   writeln('2> The second mob you can see is a mob that you can create yourself, this');
   writeln('works by typing `new mob` you can make your mob. This does not allow you to');
   writeln('create an enemy but allows you to label a group and list the people in the');
   writeln('group.');
   writeln;
   writeln(' All enemys are different in their own way.');
   writeln;
   writeln('Press Enter to continue...');
   readln;
 end

   else

    If helpchoose = 'H' then
 begin
   clrscr;
   writeln('This text based game was created by AchromiciA & Crizmal');
   writeln('Beta v1.0 completed [enter date here]');
   writeln('Copyrighted by Crizmal & AchromiciA');
   writeln('Email AchromiciA - sick_dog_rap@Yahoo.com');
   writeln('Email Crizmal - crizmal@hotmail.com');
   writeln('This game was made by Turbo Pascal v7.0');
   writeln;
   writeln('Press Enter to exit...');
   readln;
 end;

     Until helpchoose = 'Q';

     If helpchoose = 'Q' then
 begin
 textcolor(11+128);
   write('Sure you want to quit help (Y/N) :  ');
   readln(quithelp);
   quithelp:= UPCASE(quithelp);
 end;
    If quithelp = 'N' then
 begin
   help;
 end;
end;

Procedure Inventory;
begin
  Writeln(c.Pname,'`s Inventory');
  Writeln('------------------------------');
  Writeln('|Item name|   |Weight|   |No.|');
  Writeln('------------------------------');
  Writeln;
  Writeln;
  Writeln('------------------------------');
  Writeln('Max no. Items(',c.maxinv,') Max Weight(',c.maxmass,')');
end;

Procedure Delete_char;
begin
  begin
    repeat
    clrscr;
    textcolor(14+128);
    writeln(' Are you sure you want to delete your character (You will never be');
    writeln('able to use charater again) [Y/N]?');
    readln(suredel);
    textcolor(14);
    Until suredel in ['Y','N','y','n'];
    suredel := UPCASE(suredel);
     If suredel = 'Y' then
   begin
     writeln;
     writeln('Removing player stats...');
     assign(f, 'c:\tp\turbo\amenc\save\'+c.pname+'.ame');
     reset(f);
     erase(f);
     close(f);
      assign(f, 'c:\tp\turbo\amenc\save\mobs.ame');
      reset(f);
      erase(f);
      close(f);
      writeln('Player deleted, all files removed!');
      readln;
      Halt(0);
   end

     else

     If suredel = 'N' then
   begin
     Writeln;
     writeln('Wise choice!');
   end;
end;
end;

Procedure New_mob;
begin
clrscr;
  writeln('Welcome to the new group creator segment.');
  writeln;
  writeln('In this version you will not be able to list or create any groups.');
  writeln('Please wait until the Full version comes out.');
  readln;
  clrscr;
  writeln('But this will give you the lay down on this segment.');
  readln;
  writeln;
  writeln('           When activated this segment will show one line saying,');
  writeln('            `Are you sure that you want to list a new group [Y/N]`');
  writeln('    You can react the way you want to but if `Y` it reacts as follows.');
  readln;
  writeln;
  writeln('The screen will display the box:');
  readln;
  writeln;
  writeln('-----------------------------------------');
  writeln('|Mobs name|          |Character''s in group|');
  writeln('-----------------------------------------');
  writeln(Mobname,'                 ',mobchar[1]);
  writeln('-----------------------------------------');
  writeln(' You may only have one mob, but a max of 6');
  writeln('people in your group.');
  writeln('-----------------------------------------');
  readln;
  clrscr;
  writeln('  Then you will need to type in how many people you are going to have in');
  writeln('your group. Then you type in the names of the characters in your group then');
  writeln('the main computer checks if those characters are real or not.');
  writeln('  If they are real the character''s name is created and stored in your friends');
  writeln('list, maybe some updates will be made for this list so we will work on it.');
  readln;
end;



Procedure Statistics_char;
begin
end;

procedure save;
begin
   repeat
  clrscr;
  write('Are you sure that you want to save your current character:');
  readln(Syn);
   until syn in ['y','n','Y','N'];
  syn:=upcase(syn);
   if syn = 'Y' then
 begin
  writeln('Saving character...');
  assign(z, 'c:\tp\turbo\amenc\save\'+c.pname+'.ame');
  reset(z);
  write(z, c);
  close(z);
  writeln('Save complete!');
  readln;
end;
end;

Procedure Load;
begin
  clrscr;
    repeat
  writeln('What do you want to load : <Character>');
  readln(loadche);
    Until loadche > '';
 for count := 1 to length(loadche) do
  loadche[count]:=upcase(loadche[count]);
   if loadche = 'CHARACTER' then
 begin
  clrscr;
     repeat
   write('Do you want to save your current character first :');
   readln(suredel);
     Until suredel in ['y','n','Y','N'];
      suredel:=upcase(suredel);
    if suredel = 'Y' then
  begin
      writeln('Saving character...');
      assign(z, 'c:\tp\turbo\amenc\save\'+c.pname+'.ame');
      reset(z);
      write(z, c);
      close(z);
      writeln('Save complete!');
  end;

   write('What is the characters name that you want to load :');
   readln(name);

   assign(z, 'c:\tp\turbo\amenc\save\'+name+'.ame');
   reset(z);
   read(z, c);
   close(z);
 clrscr;
 textcolor(10);
  writeln('                             Loading...');
  writeln;
  writeln('                      Players name |',c.Pname,'|');
  writeln('                       Player type |',c.Ptype,'|');
  writeln('                          strength |',c.str,'|');
  writeln('                         dexterity |',c.dex,'|');
  writeln('                            armour |',c.arm,'|');
  writeln('                      intelligence |',c.int,'|');
  writeln('                    Current Health |',c.chp,'|');
  writeln('                            Health |',c.hp,'|');
  writeln('                     Current level |',c.levelc,'|');
  writeln('                Current Experience |',c.expgot,'|');
  Writeln('                 Needed Experience |',c.expneed,'|');
  writeln('          Maximum Inventory weight |',c.maxmass,'|');
  writeln('            Maximum Inventory size |',c.maxinv,'|');
  writeln('                      Current mana |',c.cmana,'|');
  writeln('                      Maximum mana |',c.mana,'|');
  readln;
end;
end;

Procedure Skills;
begin
end;

Procedure Equipment;
begin
writeln;
writeln('-----------------------------------------');
writeln('|Item name|      |Quantity|      |Weight|');
writeln('-----------------------------------------');
writeln(Items,'              ',c.nitems,'         ',c.witems);
writeln('-----------------------------------------');
end;

Procedure Friend_mobs;
begin
Writeln('Your current friendly mobs are...');
writeln('-----------------------------------------');
writeln('|Mobs name|          |Character''s in mob|');
writeln('-----------------------------------------');
writeln(Mobname,'                 ',mobchar[1]);
writeln('-----------------------------------------');
end;


Procedure main_commands;
begin
  textcolor(13);
  tick:=0;
  writeln('At any time if there are any problems type in Help.');
  gettime(h, m, s, hund);
  time:=(h*360);
  time:=(time*10)+(m*60)+(s);
  y:=0;
  repeat

  textcolor(12);
  Write('<',c.chp,'hp|',c.hp,'hp * ',c.cmana,'m|',c.mana,'M * ',c.expgot,' C Exp|',c.expneed,' N Exp>   :   ');
  Readln(maincom);
  gettime(h, m, s, hund);
 comptime:=(h*360);
 comptime:=(comptime*10)+(m*60)+(s)+y;
 diff:=comptime-time;
 x:=0;
 if diff >= 10 then
 begin
 x:=diff div 10;
 y:=diff mod 10;
 tick:=tick+x;
 writeln(tick);
 time:=comptime;
 end;
  for count := 1 to length(maincom) do
      maincom[count] := UPCASE(maincom[count]);

   If maincom = 'NEW MOB' then
 begin
 textcolor(14);
  New_mob;
 end;

   If (maincom = 'INVENTORY') or (maincom ='INVENTOR') or
    (maincom ='INVENTO') or (maincom ='INVENT') or
    (maincom ='INVEN') or (maincom ='INVE') or
    (maincom ='INV') or (maincom ='IN') then
 begin
 textcolor(14);
  Inventory;
 end

  else


   If (maincom = 'DELETE') or (maincom = 'DELET') or
    (maincom = 'DELE') or (maincom = 'DEL') or
    (maincom = 'DE') then
 begin
 textcolor(14);
  Delete_char;
 end

  else

   If (maincom = 'SAVE') or (maincom = 'SAV') or
    (maincom = 'SA') then
  begin
   textcolor(14);
   save;
  end

   else
   
   If (maincom = 'STATISTICS') or (maincom = 'STATISTIC') or
    (maincom = 'STATISTI') or (maincom = 'STATIST') or
    (maincom = 'STATIS') or (maincom = 'STATI') or
    (maincom = 'STAT') or (maincom = 'STA') or
    (maincom = 'ST') or (maincom = 'STATS') then
 begin
 textcolor(14);
  Statistics_char;
 end

  else

 If (maincom = 'NORTH') or (maincom = 'NORT') or
 (maincom = 'NOR') or (maincom = 'NO') or
 (maincom = 'N') or (maincom = 'SOUTH') or
 (maincom = 'SOUT') or (maincom = 'SOU') or
 (maincom = 'SO') or (maincom = 'S') or
 (maincom = 'WEST') or (maincom = 'WES') or
 (maincom = 'WE') or (maincom = 'W') or
 (maincom = 'EAST') or (maincom = 'EAS') or
 (maincom = 'EA') or (maincom = 'E') or
 (maincom = 'UP') or (maincom = 'U') or
 (maincom = 'DOWN') or (maincom = 'DOW') or
 (maincom = 'DO') or (maincom = 'D') then
 begin
   textcolor(14);
   writeln('You can`t move yet, considering there isn`t even a map to move on.');
 end

  else

 If (maincom = 'HELP') or (maincom = 'HEL') or
  (maincom = 'HE') then
 begin
  Help;
 end

   else

   If (maincom = 'EQUIPMENT') or (maincom = 'EQUIPMEN') or
    (maincom = 'EQUIPME') or (maincom = 'EQUIPM') or
    (maincom = 'EQUIP') or (maincom = 'EQUI') or
    (maincom = 'EQU') or (maincom = 'EQ') then
 begin
 textcolor(14);
  Equipment;
 end

  else

   if (maincom = 'LOAD') or (maincom = 'LOA') or
    (maincom = 'LO') then
 begin
 textcolor(14);
  Load;
 end

   else

   If (maincom = 'SKILLS') or (maincom = 'SKILL') or
    (maincom = 'SKIL') or (maincom = 'SKI') or
    (maincom = 'SK') then
 begin
 textcolor(14);
  Skills;
 end

  else

  
   If (maincom = 'FRIENDS') or (maincom = 'FRIEND') or
    (maincom = 'FRIEN') or (maincom = 'FRIE') or
    (maincom = 'FRI') or (maincom = 'FR') then
 begin
 textcolor(14);
    Friend_mobs;
 end;

until (maincom = 'QUIT') or (maincom = 'QUI') or
    (maincom = 'QU') or (maincom = 'Q');

if (maincom = 'QUIT') or (maincom = 'QUI') or
    (maincom = 'QU') or (maincom = 'Q') then
begin
textcolor(11+128);
write('Do You Really Want To Quit (Y/N) : ');
readln(quitgame);
quitgame := UPCASE(quitgame);
end;
if quitgame = 'Y' then halt(0)

                  else main_commands;

end;


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
     writeln('       Created by AchromiciA & Crizmal                    AMENC v1.1 Alpha');

end;


Procedure Advanced_training;
begin
clrscr;
textcolor(10);
writeln('                   You have now entered Advanced training!');
readln;
end;

Procedure Basic_training;
begin
writeln('                   You have now entered Basic training!');
Writeln;
writeln('                          Press enter to continue.');
readln;
clrscr;
writeln('             First we will tell you about your HUD or display.');
readln;
writeln('In this Beta version you will not be able to configure your display but this');
writeln('                    will be acceptable in the full version.');
readln;
clrscr;
writeln;
writeln('   First in this beta version the command line will be all you will see.');
readln;
writeln('          Your command line is displayed in from left to right-');
readln;
writeln;
writeln('                           :Current Health [hp]');
writeln('                           :Maximum Health [hp]');
writeln('                           :Current mana [m]');
writeln('                           :Maximum mana [M]');
writeln('                           :Current Experience [C Exp]');
writeln('                           :Needed Experience [N Exp');
readln;
writeln;
writeln('                    An example of your HUD would be as shown.');
Writeln('                  <',c.chp,'hp|',c.hp,'hp * ',c.cmana,'m|',c.mana,'M * ',c.expgot,' C Exp|',c.expneed,' N Exp>');
readln;
clrscr;
writeln;
Writeln('    Now we will tell teach you how to get the computer to react to your');
writeln('                                    commands.');
writeln;
writeln;
readln;
writeln('     You will need to give the computer direct commands, which shall be');
writeln('                           typed underneath the HUD.');
writeln;
writeln;
readln;
clrscr;
writeln;
writeln;
writeln('  Some examples of these commands are... Inventory, Equipment, Skills, and');
writeln('          more that you will learn later in the training area.');
readln;
writeln;
writeln('But some of these commands can be shortended in smaller words... Inventory');
writeln('  (Inv), Equipment(eq), Skills(Sk), and again we will teach you later in');
writeln('                          this training area.');
readln;
repeat
gotoxy(5,13);
write('Would you like to continue to Advanced Training or Play Amenc : ');
readln(bora);
Bora := UPCASE(bora);
until bora in['P','A'];
If bora = 'A' then
begin
advanced_training;
end;
if bora = 'P' then
begin
clrscr;
gotoxy(0,14);
main_commands;
end;


end;

Procedure Training;
begin
 repeat
 clrscr;
textcolor(14);
Write('Would you like to do training before playing (Y/N) : ');
Readln(trainagain);
Until trainagain in ['Y','N','y','n'];
trainagain:=UPCASE(trainagain);
If trainagain = 'N' then
begin
   Main_commands;
end;

Clrscr;
writeln('Welcome to Training for AMENC v1.0 Beta this program will give you the low');
writeln('                      down for the structure of this game.');
writeln;
Writeln('                           Press Enter to Continue.');
Readln;

clrscr;

Write('What do you want to do... [Basic Training/Advanced Training/Play] : ');
readln(bora);
bora:=UPCASE(bora);

if bora = 'B' then
begin
  Basic_training;
end;

if bora = 'A'then
begin
  Advanced_Training;
end;

if bora = 'P' then
begin
main_commands;
end;

end;

Procedure statistics;
begin
mobname:='This function is not avaliable on the Alpha Version.';
mobchar[1]:='0';
   If c.Ptype = 'Amazon' then
 begin
  c.str := 12;
  c.dex := 30;
  c.arm := 3;
  c.int := 15;
  c.chp := 200;
  c.hp := 200;
  c.cmana := 25;
  c.mana := 25;
  c.levelc := 1;
  c.expgot := 0;
  c.expneed := 250;
  c.maxmass := 240;
  c.maxinv := 80;
 end

    else

   If c.Ptype = 'Warrior' then
 begin
  c.str := 25;
  c.dex := 10;
  c.arm := 8;
  c.int := 5;
  c.chp := 130;
  c.hp := 130;
  c.cmana := 12;
  c.mana := 12;
  c.levelc := 1;
  c.expgot := 0;
  c.expneed := 250;
  c.maxmass := 325;
  c.maxinv := 40;
 end

    else

   If c.Ptype = 'Elf' then
 begin
  c.str := 8;
  c.dex := 20;
  c.arm := 10;
  c.int := 30;
  c.chp := 300;
  c.hp := 300;
  c.cmana := 40;
  c.mana := 40;
  c.levelc := 1;
  c.expgot := 0;
  c.expneed := 150;
  c.maxmass := 240;
  c.maxinv := 24;
 end

    else

   If c.Ptype = 'Peasent' then
 begin
  c.str := 15;
  c.dex := 18;
  c.arm := 5;
  c.int := 20;
  c.chp := 240;
  c.hp := 240;
  c.cmana := 30;
  c.mana := 30;
  c.levelc := 1;
  c.expgot := 0;
  c.expneed := 200;
  c.maxmass := 360;
  c.maxinv := 72;
 end;

assign(z, 'c:\tp\turbo\Amenc\save\'+c.pname+'.ame');
rewrite(z);
write(z, c);
close(z);

writeln;
Writeln('strength = ', c.str);
Delay(200);
Writeln('dexterity = ', c.dex);
Delay(250);
Writeln('armour = ', c.arm);
Delay(100);
writeln('intelligence = ', c.int);
Delay(800);
writeln('Current Health = ',c.chp);
Delay(300);
Writeln('Health = ', c.hp);
Delay(100);
writeln('Current mana = ',c.cmana);
Delay(100);
writeln('Maximum mana = ',c.mana);
Delay(500);
writeln('Current experience = ',c.expgot);
Delay(480);
writeln('Needed experience = ',c.expneed);
Delay(100);
writeln('Maximum Inventory weight = ',c.maxmass);
Delay(200);
writeln('Maximum Inventory size = ',c.maxinv);
Delay(200);
Writeln('Player Level = ', c.levelc);
Delay(800);
Writeln('Player type = ', c.Ptype);
Readln;

Training;

end;

Procedure CharName;
begin
 repeat
  Clrscr;
  Write('What do you want to call your character for this game : ');
  Readln(c.Pname);

  repeat
  Clrscr;
  Writeln('            ',c.Pname,' will be your name for the rest of the game,');
  write('                   are you sure you want to keep it   :   ');
  Readln(nametrue);
  Until nametrue in ['Y','N','y','n'];
  nametrue:=UPCASE(nametrue);
 Until nametrue = 'Y';
end;

Procedure Character_set;
begin
 Clrscr;
 Writeln('                       Allocating player stats...');


   If SPT = 'a' then
  begin
    c.Ptype := 'Amazon'
  end

    else

   If SPT = 'b' then
  begin
    c.Ptype := 'Warrior'
  end

    else

   If SPT = 'c' then
  begin
    c.Ptype := 'Elf'
  end

    else

   If SPT = 'd' then
  begin
    c.Ptype := 'Peasent'
  end;


end;

Procedure Character;
begin
textcolor(13);
  repeat
  Clrscr;
  Writeln('      What type of character do you what to use for your adventure...');
  Writeln;
  Writeln('                    Type the letter of your choice');
  Writeln;
  Writeln('                            <a> Amazon');
  Writeln('                            <b> Warrior');
  Writeln('                            <c> Elf');
  Writeln('                            <d> Peasent');
  Writeln;
  write('                   Please type letter in lower case : ');
  Readln(SPT);
  Until SPT in ['a','b','c','d'];

  repeat
  Clrscr;
  Write('   Are you sure that you want to choose this character (Y/N) : ');
  Readln(Chartrue);
  Until Chartrue in ['Y','N','y','n'];
  Chartrue:=UPCASE(Chartrue);
  If Chartrue = 'N' then
  begin
  character;
  end;
  
end;

procedure start;
  begin
  Writeln('Welcome to');
  textcolor(13);
  delay(500);
  writeln('                  /\');
  Writeln('                 /  \                                   ||=======');
  Writeln('                /    \      |-      -|                  ||');
  Writeln('               /  /\  \     | \    / |                  ||');
  Writeln('              /  /  \  \    |  \  /  | ||===== ||====\  ||');
  Writeln('             /   ----   \   ||\ \/ /|| ||      ||====\\ ||');
  Writeln('            /            \  || \--/ || ||===   ||    || ||');
  Writeln('           /   /------\   \ ||      || ||      ||    || ||');
  Writeln('          /   /        \   \||      || ||===== ||    || ||=======');
  delay(700);


Writeln;
Writeln;
textcolor(white);
Writeln('                         Press enter to continue.');
Readln;


repeat
clrscr;

textcolor(12);
Write('           Have you got a character previously created (Y/N) : ');
Readln(Pre);
Until Pre in ['y','Y','n','N'];
Pre:=UPCASE(pre);
 If Pre = 'Y' then
 begin
 writeln;
 write('           What is your existing character''s name : ');
 readln(name);

 assign(z, 'c:\tp\turbo\Amenc\save\'+name+'.ame');
 reset(z);
 read(z, c);
 close(z);

 
 clrscr;
 textcolor(10);
 writeln('                             Loading...');
 writeln;
 writeln('                      Players name |',c.Pname,'|');
 writeln('                       Player type |',c.Ptype,'|');
 writeln('                          strength |',c.str,'|');
 writeln('                         dexterity |',c.dex,'|');
 writeln('                            armour |',c.arm,'|');
 writeln('                      intelligence |',c.int,'|');
 writeln('                    Current Health |',c.chp,'|');
 writeln('                            Health |',c.hp,'|');
 writeln('                     Current level |',c.levelc,'|');
 writeln('                Current Experience |',c.expgot,'|');
 Writeln('                 Needed Experience |',c.expneed,'|');
 writeln('          Maximum Inventory weight |',c.maxmass,'|');
 writeln('            Maximum Inventory size |',c.maxinv,'|');
 writeln('                      Current mana |',c.cmana,'|');
 writeln('                      Maximum mana |',c.mana,'|');
 readln;
 main_commands;
end;
end;

begin
clrscr;
menu_window;
message_window;
start;
character;
charname;
character_set;
statistics;
training;


end.