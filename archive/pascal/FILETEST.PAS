PROGRAM fileTest;

USES
    crt;

TYPE
    HiScoreEntry = RECORD
                         name:string[10];
                         score:integer;
                   END;
    HiScoreTable = FILE OF HiScoreEntry;


VAR
   hiScoreFile:HiScoreTable;
   hiScore2,hiScore3:hiScoreEntry;
   F:text;
   JJ:string;
   x:integer;

BEGIN
     Assign(hiScoreFile, 'NEWFILE.TXT');
     Rewrite(hiScoreFile);
     FOR x := 1 TO 10 DO
     BEGIN
     hiScore2.name := 'Joshua';
     hiScore2.score := x;
     write(hiScoreFile, hiscore2);
     END;
     Close(hiScoreFile);
     assign(hiScoreFile, 'NEWFILE.TXT');
     reset(hiScoreFile);
     FOR x := 1 TO 10 DO
     BEGIN
     read(hiScoreFile,hiScore3);
     writeln(hiScore3.name,' ',hiScore3.score);
     END;
     readkey;
     close(hiScoreFile);
END.