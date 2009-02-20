Program Chopfest;
Uses Crt;
var
   Key : Char;
   i : integer;
   P1Name : String[30];
   P2Name : String[30];
   P2Top : String[7];
   P2Mid : String[7];
   P2Bot : String[7];
   P1Top : String[7];
   P1Mid : String[7];
   P1Bot : String[7];
   P1HP : Integer;
   P2HP : Integer;

Procedure ReDraw; forward;

Function NameExtension : String;
var
   Key : Char;
begin
     writeln('*********************************');
     writeln('Choose a title for your fighter - ');
     writeln('(a)    Warrior');
     writeln('(b)    Ninja');
     writeln('(c)    Black');
     writeln('(d)    Dangerous');
     writeln('(e)    Monstrous');
     writeln('(f)    Super Saiyan');
     writeln('(g)    Wanker');
     writeln('(h)    Elephant');
     writeln('(i)    Dragon');
     writeln('(j)    Android');
     writeln('(k)    Namekian');
     repeat
           Key := ReadKey;
           Key := UPCASE(Key);
     until Key in ['A','B','C','D','E','F','G','H','I','J','K'];

     Case Key of
          'A' : NameExtension:= 'Warrior';
          'B' : NameExtension:= 'Ninja';
          'C' : NameExtension:= 'Black';
          'D' : NameExtension:= 'Dangerous';
          'E' : NameExtension:= 'Monstrous';
          'F' : NameExtension:= 'Super Saiyan';
          'G' : NameExtension:= 'Wanker';
          'H' : NameExtension:= 'Elephant';
          'I' : NameExtension:= 'Dragon';
          'J' : NameExtension:= 'Android';
          'K' : NameExtension:= 'Namekian';
     end;

end;

Function Damage:integer;
begin
     case Key of
          'Z','1' : begin
          Damage:=5
          end;
          'X','2' : begin
          Damage:=3
          end;
          'C','3' : begin
          Damage:=6
          end;
          'A','4' : begin
          Damage:=10
          end;
     end;
end;

Procedure DrawFight;
begin
     clrscr;

     writeln(P1Name,' vs. ',P2Name);
     writeln;
     writeln;
     writeln;
     writeln;
     writeln;
     writeln;
     writeln(P1Name,'    HP= ',P1HP);
     writeln(P2Name,'    HP= ',P2HP);
     writeln;
     writeln('                                    ',P1Top,P2Top);
     writeln('                                    ',P1Mid,P2Mid);
     writeln('                                    ',P1Bot,P2Bot);
     writeln;
     writeln;
     writeln('Do you wish to play again?')
end;

Procedure P1Die;
begin
     P1Top:=' lose. ';
     P1Mid:='       ';
     P1Bot:=' O-|-= ';
     P2Top:=' O    W';
     P2Mid:='\|/   I';
     P2Bot:='/ \   N';
     P1HP:=0;
     P2HP:=999;
     DrawFight;

end;

Procedure P2Die;
begin
     P1Top:='W    O ';
     P1Mid:='I   \|/';
     P1Bot:='N   / \';
     P2Top:=' lose. ';
     P2Mid:='       ';
     P2Bot:=' =-|-O ';
     P1HP:=999;
     P2HP:=0;
     DrawFight;
end;

Procedure P1HurtP2;
begin
     P2HP:= P2HP-Damage;
     Sound(Damage*200);Delay(Damage);NoSound;
end;

Procedure P2HurtP1;
begin
     P1HP:=P1HP-Damage;
     Sound(Damage*200);Delay(Damage);NoSound;
end;

Procedure Quit;
begin
     clrscr;
     writeln('Thank you for playing ChopFest!!! Goodbye!');
     writeln('Created by Matthew Joiner (c) Feb 2002');
     writeln('All rights reserved.');
     writeln('(You shouldn`t read this stuff)');
     Key:=ReadKey;
     Halt;
end;

Procedure SplashScreen;
begin
     clrscr;
     writeln('Welcome to Chopfest 2002 beta version 0.02');
     writeln('Press any key to continue');
     Key:=ReadKey;
end;

Procedure Fight;
begin
     if P1HP <= 0 then
     P1Die;
     if P2HP <= 0 then
     P2Die;

     ReDraw;
     delay(300);
     P1Top:='   O   ';
     P1Mid:='  -|-  ';
     P1Bot:='  / \  ';
     P2Top:='   O   ';
     P2Mid:='  -|-  ';
     P2Bot:='  / \  ';
     ReDraw;
     repeat
           Key:=ReadKey;
           Key:=UpCase(Key);
     until Key in ['Z','X','Q','C','1','2','3','A','4'];

     Case Key of
     'C' :begin
         P1Top:='   /O  ';
         P1Mid:='  -|-  ';
         P1Bot:='  / \  ';
         P1HurtP2;
         end;
     'Z' : begin
         P1Top:='   O   ';
         P1Mid:='  -|/  ';
         P1Bot:='  /    ';
         P1HurtP2;
         end;
     'X' : begin
         P1Top:='   O   ';
         P1Mid:='  -|-o ';
         P1Bot:='  / \  ';
         P1HurtP2;
         end;
     'Q' : begin
         writeln('Do you wish to quit? (y/n) - ');
         repeat
               Key:=ReadKey;
               Key:=UpCase(Key);
               until Key in ['Y','N'];
         if Key = 'Y' then
         Quit;
         end;
     '1' : begin
         P2Top:='   O   ';
         P2Mid:='  \|-  ';
         P2Bot:='    \  ';
         P2HurtP1;
         end;
     '2' : begin
         P2Top:='   O   ';
         P2Mid:=' o-|-  ';
         P2Bot:='  / \  ';
         P2HurtP1;
         end;
     '3' : begin
         P2Top:='  O\   ';
         P2Mid:='  -|-  ';
         P2Bot:='  / \  ';
         P2HurtP1;
         end;
     'A' : begin
         P1Top:='  O    ';
         P1Mid:='  |{--O';
         P1Bot:='  |\   ';
         P1HurtP2;
         end;
     '4' : begin
         P2Top:='    O  ';
         P2Mid:='O--}|  ';
         P2Bot:='   /|  ';
         P2HurtP1;
         end;
     end;
Fight;
end;

Procedure PlayerSetup;
begin
     clrscr;
     write('Please type in the name of Player 1 - ');
     readln(P1Name);
     P1Name:= P1Name + ' the ' + NameExtension;

     clrscr;
     write('Player 1`s name is - ');
     writeln(P1Name);
     writeln;
     write('Please type in the name of Player 2 - ');
     readln(P2Name);
     P2Name:= P2Name + ' the ' + NameExtension;

     clrscr;
     writeln('Your fighter`s names are - ');
     writeln(' * ',P1Name);
     writeln(' * ',P2Name);
     write('Is this correct? (y/n) - ');
     repeat
           Key:=ReadKey;
           Key:=UPCASE(Key)
    until Key in ['Y','N'];

    if Key = 'N' then
    PlayerSetup

end;

Procedure PrepareCombat;
begin
     P1Top:='   O   ';
     P1Mid:='  -|-  ';
     P1Bot:='  / \  ';
     P2Top:='   O   ';
     P2Mid:='  -|-  ';
     P2Bot:='  / \  ';
     P1HP:=400;
     P2HP:=400;
end;

Procedure Redraw;
begin
     clrscr;

     writeln(P1Name,' vs. ',P2Name);
     writeln;
     writeln;
     writeln;
     writeln;
     writeln;
     writeln;
     writeln(P1Name,'    HP= ',P1HP);
     writeln(P2Name,'    HP= ',P2HP);
     writeln;
     writeln('                                    ',P1Top,P2Top);
     writeln('                                    ',P1Mid,P2Mid);
     writeln('                                    ',P1Bot,P2Bot);
end;

begin
SplashScreen;
PlayerSetup;
PrepareCombat;
Fight;
end.