PROGRAM mathdemo;

USES
    crt;
VAR
   num1,num2,times,plus,divide,modulus,square:longint;

PROCEDURE evilmusic;

BEGIN
     SOUND(164);
     DELAY(400);
     NOSOUND;
     SOUND(130);
     DELAY(350);
     NOSOUND;
     SOUND(113);
     DELAY(450);
     NOSOUND;
END;

BEGIN
     CLRSCR;
     TEXTCOLOR(15);
     WRITE('Welcome to ');
     evilmusic;
     TEXTCOLOR(14+128);
     WRITELN('THE PASCAL MATH DEMO!');
     TEXTCOLOR(10);
     WRITELN('================================');
     DELAY(1000);
     TEXTCOLOR(15);
     WRITELN;
     WRITE('Please enter an ');
     evilmusic;
     TEXTCOLOR(12);
     WRITELN('INTEGER!');
     TEXTCOLOR(15);
     READLN(num1);
     WRITELN;
     WRITE('Please enter ');
     evilmusic;
     TEXTCOLOR(12);
     WRITELN('ANOTHER INTEGER!');
     TEXTCOLOR(15);
     READLN(num2);
     CLRSCR;
     TEXTCOLOR(15);
     times := num1 * num2;
     plus := num1 + num2;
     divide := num1 DIV num2;
     modulus := num1 MOD num2;
     square := sqr(num1);
     WRITELN('The product of ',num1,' and ',num2,' is ',times,'.');
     WRITELN(num1,' plus ',num2,' equals ',plus,'.');
     WRITELN(num1,' divided by ',num2,' equals ',divide,' with a remainder of ',modulus,'.');
     WRITELN('The square of ',num1,' is ',square,'.');
     REPEAT
     UNTIL KeyPressed;
END.