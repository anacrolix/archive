Program Game;
Uses Dos, Crt, Graph;

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


Procedure DisplayStats;
begin
  clrscr;

  With Stats do
  begin
    Write(Name ,'               ');

    IF Type1 = 'A' then
    begin
      Write('Amazon');
    end
      else
    IF Type1 = 'B' then
    begin
      Write('Barbarian');
    end
      else
    begin
      Write('Sorcerer,');
    end;

    Writeln(' Level - ',Lvl);
    Writeln('  Current Experience - ',Expg);
    Writeln('   Needed Experience - ',Expn);
    Writeln('            Strength - ',Str);
    Writeln('           Dexterity - ',Dex);
    Writeln('        Intelligence - ',Int);
    Writeln;
    Writeln('Vitality - ',CurHp,' of ',Vit);
    Writeln('Energy - ',CurMana,' of ',Ene);
    Writeln;
  end;

  ReadKey;

  IF New = '1' then
  begin
    New := ' ';
    Save;
  end;
end;


Procedure help;
begin
    repeat
  clrscr;
  Writeln('Select your help topics from the list below - <1> Commands');
  Writeln('                                              <2> Fighting');
  Writeln('                                              <3> Movement');
  Writeln('                                              <4> Inventory');
  Writeln('                                              <5> Leveling');
  Writeln('                                              <6> Enemies');
  Writeln('                                              <7> Equipment');
  Writeln('                                              <8> Command');
  Writeln('                                              <9> Quit');
  Qes := ReadKey;
    until Qes in ['1','2','3','4','5','6','7','8','9'];

Case Qes of
  '1': begin
    clrscr;
    Writeln('The following commands can be used at anytime on the command.');
    Writeln('See the Command Help Topic for more information');
    Writeln('All commands may be shortened to minimum of 3 characters');
    Writeln;
    Writeln('Movement Commands -');
    Writeln('       North : Move North,             South : Move South');
    Writeln('       West : Move West,               East : Move East');
    Writeln;
    Writeln('Character Commands-');
    Writeln('       Inventory : Access Inventory,   Equipment : Access Equipment');
    Writeln('       Statistics : Access Stats,      Help : Enter Here');
    Writeln('       Sleep : Put character to sleep, Rest : Makes character rest');
    Writeln('       Awake : Wakes character up,     Wake up : same as Awake');
    Writeln('       Get up : same as Awake (Must be at least 4 letters)');
    Writeln;
    Writeln('General Commands-');
    Writeln('       Save : Save Character,          Load : Load a new character');
    Writeln('       Scan : Look around the area,    Look : Show Description again');
    Writeln('       Colour : Change colour of HUD,  Quit : Quits the game');
    Writeln('       Delete : Delete Selected character');
    ReadKey;
    help;
  end;

  '2': begin
    Writeln('Have not done this yet');
    ReadKey;
    help;
  end;

  '3': begin
    clrscr;
    Writeln('There are 4 movement controls to control your character around the area');
    Writeln(' While navigating yourself around the world you will find you have barriers ');
    Writeln('stopping you from walking out of the maps boundries. In the full version you');
    Writeln('will be able to walk up and down. While walking around you will find friendly');
    Writeln('mobs and hostile mobs, to find these mobs before you need to fight them ues the');
    Writeln('command `Scan,` this will tell you side to side. As soon as you have reached the');
    Writeln('same room as the mobs they will attack if they are hostile.');
    ReadKey;
    help;
  end;

  '4': begin
    Writeln('Have not done this yet');
    ReadKey;
    help;
  end;

  '5': begin
    clrscr;
    Writeln('Leveling is basically just a way of making your character stronger.');
    Writeln(' The way to level is to kill enough enemies to raise your experience above or');
    Writeln('equal your needed experience. Once you go up a level all your statistics will');
    Writeln('increase in value. Your maximum level is 120 as soon as you hit 120 you will');
    Writeln('not gain anymore experience.');
    ReadKey;
    help;
  end;

  '6': begin
    clrscr;
    Writeln(' You will encounter many different enemies and they will all be set on the map');
    Writeln('that your character might be playing.');
    Writeln(' Enemies will increase in strength as you progress through the game and you ');
    Writeln('will also gain more experience from defeating them. Be warned that enemy mobs');
    Writeln('may come up in different amounts of enemies, meaning that an enemy may be in a');
    Writeln('group.');
    ReadKey;
    help;
  end;

  '7': begin
    Writeln('Have not done this yet');
    ReadKey;
    help;
  end;

  '8': begin
    clrscr;
    Writeln('Your command is basically you line where you type in all your game commands.');
    Writeln('This is how your command is represented on the screen from left to right');
    Writeln;
    Writeln('-Current Health');
    Writeln('-Maximum Health');
    Writeln('-Current Mana');
    Writeln('-Maximum Mana');
    Writeln('-Experience Receved');
    Writeln('-Experience Needed for a Level');
    Writeln;
    Writeln('Example of Command : Area Name - Tutorial');
    Writeln('                     Co-ordinates - 1,6');
    Writeln('                     Room Description - Really Big');
    Writeln('                     <100hp-135HP : 3m-5M : 12-340 Exp>');
    ReadKey;
    help;
  end;

end;
  clrscr;
end;


Procedure ShowInv;
begin
end;


Procedure ChangeColour;
begin
    repeat
  clrscr;
  TextColor(White);
  Writeln('Select the new colour from the list below for your background');
  Writeln;

  TextColor(Black);
  Writeln('<B>lack');

  TextColor(Blue);
  Writeln('B<l>ue');

  TextColor(Green);
  Writeln('<G>reen');

  TextColor(Cyan);
  Writeln('<C>yan');

  TextColor(Red);
  Writeln('<R>ed');

  TextColor(Magenta);
  Writeln('<M>agenta');

  TextColor(Brown);
  Writeln('Br<o>wn');

  Qes := ReadKey;
    until Qes in ['b','l','g','c','r','m','o','B','L','G','C','R','M','O'];

  Qes := UPCASE(Qes);

Case Qes of
    'B': BackColour := Black;
    'L': BackColour := Blue;
    'G': BackColour := Green;
    'C': BackColour := Cyan;
    'R': BackColour := Red;
    'M': BackColour := Magenta;
    'O': BackColour := Brown;
  end;

  clrscr;
  TextBackGround(BackColour);

    repeat
  clrscr;

  TextColor(White);
  Writeln('Select the new colour from the list below for your text');
  Writeln;

  TextColor(Black);
  Writeln('<B>lack');

  TextColor(Blue);
  Writeln('B<l>ue');

  TextColor(Green);
  Writeln('<G>reen');

  TextColor(Cyan);
  Writeln('<C>yan');

  TextColor(Red);
  Writeln('<R>ed');

  TextColor(Magenta);
  Writeln('<M>agenta');

  TextColor(Brown);
  Writeln('Br<o>wn');

  TextColor(DarKGray);
  Writeln('<D>ark Gray');

  TextColor(LightGray);
  Writeln('L<i>ght Gray');

  TextColor(Yellow);
  Writeln('<Y>ellow');

  Qes := ReadKey;
    until Qes in ['b','l','g','w','c','r','i','m','o','d','y','B','L','G','C','R','M','O','D','L','Y','W','I'];

  Qes := UPCASE(Qes);

Case Qes of
    'B': TextColour := Black;
    'L': TextColour := Blue;
    'G': TextColour := Green;
    'W': TextColour := White;
    'C': TextColour := Cyan;
    'R': TextColour := Red;
    'I': TextColour := LightGray;
    'M': TextColour := Magenta;
    'O': TextColour := Brown;
    'D': TextColour := DarkGray;
    'Y': TextColour := Yellow;
  end;

  clrscr;
  TextColor(TextColour);
end;


Procedure loadchar1;
begin
    repeat
  clrscr;
  Write('Type in the name of your previously created character - ');
  Readln(temp);
    until temp <> '';

  Assign(charfile, temp + '.dcs');
  Reset(charfile);
  Read(charfile, Stats);
  Close(charfile);

  DisplayStats;
end;


Procedure DeleteChar;
begin
    repeat
  Writeln;
  Writeln;
  Write('Do you want to save your current character first? [Y/N] - ');
  Qes := ReadKey;
    until Qes in ['y','n','Y','N'];

  Qes := UPCASE(Qes);

  IF Qes = 'Y' then Save;

    repeat
  clrscr;
  Write('Type in the name of the character you wish to delete - ');
  readln(temp);
    until temp <> '';

  Writeln('Locating file...');
  Assign(charfile, temp+'.dcs');
  Writeln('Deleting Character file...');
  Reset(charfile);
  Erase(charfile);
  Writeln('Delete Sucessful!');
  Close(charfile);
  ReadKey;

  LoadChar1;
end;


Procedure GameHUD;
begin
  clrscr;


  tick := 0;
  gettime(h, m, s, hund);
  time := (h*360);
  time := (time*10) + (m*60) + (s);
  y := 0;


  Timer := 0;

  Writeln('Type in HELP at any time, but be Warned the game still runs even in help');

    repeat

  With Stats do
  begin
    Writeln;
    Writeln('Area Name - ');
    Writeln('Co-ordinates - ',NSCoor ,',', WECoor);
    Writeln('Room Description -');
    Write('<', CurHp ,'hp-', Vit ,'HP : ', CurMana ,'m-', Ene ,'M : ',expg ,'-',expn ,' Exp> ');
  end;
    readln(temp);
    Writeln;


  gettime(h, m, s, hund);
  comptime := (h*360);
  comptime := (comptime*10)+(m*60)+(s)+y;
  diff := comptime-time;
  x := 0;

  if diff >= 10 then
  begin
    x:=diff div 10;
    y:=diff mod 10;
    tick:=tick+x;
    writeln(tick);
    Writeln(Timer);
    time:=comptime;

    {Checking if sleeping}
    IF Sleep = True then
    begin
      IF Timer < 15 then
      begin

        With Stats do
        begin
          IF CurHp <> Vit then CurHp := CurHp + 3;
          IF CurMana <> Ene then CurMana := CurMana + 2;
        end;

        Timer := Timer + 1;
      end
        else
      begin
        Timer := 0;
        Sleep := False;
        Writeln('Your character has awoken!');
      end;
    end;

    {Checking if Resting}
    IF Rest = True then
    begin
      IF Timer < 10 then
      begin

        With Stats do
        begin
          IF CurHp <> Vit then CurHp := CurHp + 1;
          IF CurMana <> Ene then CurMana := CurMana + 1;
        end;

        Timer := Timer + 1;
      end
        else
      begin
        Timer := 0;
        Rest := False;
        Writeln('Your character has woken from his rest.');
      end;
    end;

  end;


  for count := 1 to length(temp) do
      temp[count] := UPCASE(temp[count]);

    {General Commands}
    IF (temp = 'SAV') or (temp = 'SAVE') then
    begin
      Save;
    end

      else

    IF (temp = 'COL') or (temp = 'COLO') or
    (temp = 'COLOU') or (temp = 'COLOUR') then
    begin
      ChangeColour;
    end

      else

    IF (temp = 'LOA') or (temp = 'LOAD') then
    begin
        repeat
      Write('Are you sure you want to load a new character [Y/N] ');
      Qes := ReadKey;
        until Qes in ['y','n','Y','N'];

      Qes := UPCASE(Qes);

      IF Qes = 'Y' then
      begin
          repeat
        Writeln;
        Write('Do you want to save your current character first [Y/N] ');
        Qes := ReadKey;
          until Qes in ['y','n','Y','N'];

        Qes := UPCASE(Qes);

        IF Qes = 'Y' then
        begin
          Save;
        end;

        Loadchar1;
      end;
    end

      else

    IF (temp = 'HEL') or (temp = 'HELP') then
    begin
      help;
    end

      else

    IF (temp = 'AWA') or (temp = 'AWAK') or
    (temp = 'AWAKE') then
    begin

      IF (Sleep = True) or (Rest = True) then
      begin
        Sleep := False;
        Writeln('Your character has awaoken for their slumber.');
      end
      else Writeln('Your character is not asleep.');

    end

      else

    IF (temp = 'WAK') or (temp = 'WAKE') or
    (temp = 'WAKE U') or (temp = 'WAKE UP') then
    begin

      IF (Sleep = True) or (Rest = True) then
      begin
        Sleep := False;
        Writeln('Your character has awaoken for their slumber.');
      end
      else Writeln('Your character is not asleep.');

    end

      else

    IF (temp = 'GET U') or (temp = 'GET UP') then
    begin

      IF (Sleep = True) or (Rest = True) then
      begin
        Sleep := False;
        Writeln('Your character has awaoken for their slumber.');
      end
      else Writeln('Your character is not asleep.');

    end

      else

    IF (temp = 'DEL') or (temp = 'DELE') or
    (temp = 'DELET') or (temp = 'DELETE') then
    begin
        repeat
      clrscr;
      Write('Are you sure that you want to Delete a character ? [Y/N] ');
      Qes := ReadKey;
        until Qes in ['y','n','Y','N'];

      Qes := UPCASE(Qes);

      IF Qes = 'Y' then DeleteChar;

    end

      else

    {Character Commands}
    IF (temp = 'INV') or (temp = 'INVE') or
    (temp = 'INVEN') or (temp = 'INVENT') or
    (temp = 'INVENTO') or (temp = 'INVENTOR') or
    (temp = 'INVENTORY') then
    begin
      ShowInv;
    end

      else

    IF (temp = 'STA') or (temp = 'STAT') or
    (temp = 'STATS') or (temp = 'STATI') or
    (temp = 'STATIS') or (temp = 'STATIST') or
    (temp = 'STATISTI') or (temp = 'STATISTIC') or
    (temp = 'STATISTICS') then
    begin
      DisplayStats;
    end

      else

    IF (temp = 'SLE') or (temp = 'SLEE') or
    (temp = 'SLEEP') then
    begin

      IF (Sleep = True) or (Rest = True) then
      begin
        Writeln('You are already in a slumber!');
      end
        else
      begin
        Writeln('Your Character lays down on the ground and drifts away in to a slumber.');
        Sleep := True;
      end

    end

      else

    IF (temp = 'RES') or (temp = 'REST') then
    begin

      IF (Sleep = True) or (Rest = True) then
      begin
        Writeln('You are already in a slumber!');
      end
        else
      begin
        Writeln('Your Character lays down on the ground and drifts away in to a slumber.');
        Rest := True;
      end

    end

      else

    {Movement Controls}
    IF (temp = 'N') or (temp = 'NO') or
    (temp = 'NOR') or (temp = 'NORT') or
    (temp = 'NORTH') then
    begin

    IF (Sleep = True) or (Rest = True) then
    begin
      Writeln('You cannot walk around when you are asleep.');
    end
      else
    begin

      With Stats do
      begin
        IF NSCoor <> 0 then
        begin
          NSCoor := NSCoor - 1;
        end

        else Writeln('You step North and find a huge concrete wall.');
      end;
    end;

    end

      else

    IF (temp = 'S') or (temp = 'SO') or
    (temp = 'SOU') or (temp = 'SOUT') or
    (temp = 'SOUTH') then
    begin

    IF (Sleep = True) or (Rest = True) then
    begin
      Writeln('You cannot walk around when you are asleep.');
    end
      else
    begin

      With Stats do
      begin
        NSCoor := NSCoor + 1;
      end;
    end;

    end

      else

    IF (temp = 'W') or (temp = 'WE') or
    (temp = 'WES') or (temp = 'WEST') then
    begin

    IF (Sleep = True) or (Rest = True) then
    begin
      Writeln('You cannot walk around when you are asleep.');
    end
      else
    begin

      With Stats do
      begin
        IF WECoor <> 0 then
        begin
          WECoor := NSCoor - 1;
        end

        else Writeln('You step West and find a huge concrete wall.');
      end;
    end;

    end

      else

    IF (temp = 'E') or (temp = 'EA') or
    (temp = 'EAS') or (temp = 'EAST') then
    begin

    IF (Sleep = True) or (Rest = True) then
    begin
      Writeln('You cannot walk around when you are asleep.');
    end
      else
    begin

      With Stats do
      begin
        WECoor := WECoor + 1;
      end;
    end;

    end;

    {Exiting Sequence}
    until (temp = 'Q') or (temp = 'QU') or
    (temp = 'QUI') or (temp = 'QUIT');

      repeat
    Write('Are you sure that you want to quit? [Y/N] ');
    Qes := ReadKey;
      until Qes in ['y','n','Y','N'];

    Qes := UPCASE(Qes);

    IF Qes = 'Y' then
    begin
      exit;
    end
    else GameHUD;
end;


Procedure loadchar;
begin
    repeat
  clrscr;
  Write('Type in the name of your previously created character - ');
  Readln(temp);
    until temp <> '';

  Assign(charfile, temp + '.dcs');
  Reset(charfile);
  Read(charfile, Stats);
  Close(charfile);

  DisplayStats;
end;


Procedure newchar;
begin
    repeat
  clrscr;
  Write('First type in a name for your character (up to 20 letters) - ');
  Readln(temp);
    until temp <> '';

  Stats.Name := temp;

    repeat
  clrscr;
  Writeln('                    Please select a character form the list');
  Writeln('--------------------------------------------------------------------------------');
  Writeln('|                                                                              |');
  Writeln('|                             <A>mazon                                         |');
  Writeln('|                             <P>aladin (Full Only)                            |');
  Writeln('|                             <R>ouge (Full Only)                              |');
  Writeln('|                             <S>orcerer                                       |');
  Writeln('|                             <N>ecormancer (Full Only)                        |');
  Writeln('|                             <B>arbarian                                      |');
  Writeln('|                                                                              |');
  Writeln('--------------------------------------------------------------------------------');
  Qes := ReadKey;
    until Qes in ['a','s','b','A','S','B'];

  Qes := UPCASE(Qes);

  Stats.Type1 := Qes;

  IF Qes = 'A' then
  begin

  With Stats do
  begin
    Str := 20;
    Dex := 35;
    Int := 17;
    Vit := 135;
    Ene := 15;
  end;

  end
    else
  IF Qes = 'B' then
  begin

  With Stats do
  begin
    Str := 35;
    Dex := 10;
    Int := 7;
    Vit := 235;
    Ene := 5;
  end;

  end
    else
  begin

  With Stats do
  begin
    Str := 15;
    Dex := 20;
    Int := 25;
    Vit := 105;
    Ene := 25;
  end;

  end;

  With Stats do
  begin
    Expg := 0;
    Expn := 340;
    CurMana := Ene;
    CurHp := Vit;
    Lvl := 1;
    NSCoor := 0;
    WECoor := 0;
    MinDam := 2;
    MaxDam := 3;
  end;

  New := '1';
  DisplayStats;

end;


Procedure Start;
begin
    repeat

  Sleep := False;
  Rest := False;

  TextColour := White;
  BackColour := Black;

  TextBackGround(BackColour);

  TextColor(TextColour);

  clrscr;

  Writeln('Some Game named Gabbo');
  Writeln;
  Write('Have you a character that you wish to load [Y/N] ');
  Qes := ReadKey;
    until Qes in ['y','n','Y','N'];

  Qes := UPCASE(Qes);

  IF Qes = 'Y' then
  begin
    loadchar;
  end
  else newchar;
end;


begin
  Start;
  GameHUD;
end.