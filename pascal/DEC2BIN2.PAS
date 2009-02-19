program DectoBin;
  uses crt,graph;

  var
    comp2numberdec: longint;
    multvalue: integer;
    decnumber: real;
    decnumber2: real;
    binnumber: string;
    factor: real;
    binlength: real;
    bitlengthinput: real;
    bitlengthdec: real;
    bitlength1: real;
    bitlengthdec2: real;
    yesno, saveQ: char;
    multiple, x: integer;
    x1,x2,y1,y2: integer;
    xt1, xt2, yt1, yt2 : integer;
    comp1number : array[1..38] of char;
    index : integer;
    f : text;
    filename : string[8];
    result1: string;


  procedure talkwindow;
    begin
      xt1:=5;yt1:=22;xt2:=78;yt2:=23;
      window(xt1,yt1,xt2,yt2);
      textbackground(black);
      clrscr;
      window(xt1-1,yt1-1,xt2-1,yt2-1);
      textbackground(red);
      clrscr;
      textcolor(black);
    end;


  procedure showwindow;
    begin
      x1:=5;y1:=3;x2:=78;y2:=20;
      window(x1,y1,x2,y2);
      textbackground(black);
      clrscr;
      window(x1-1,y1-1,x2-1,y2-1);
      textbackground(red);
      clrscr;
      textcolor(black);
    end;


  procedure inputdecimal;
  label Next;
    begin
      textbackground(green);
      clrscr;
      write('                    ');
      textcolor(yellow + 128);
      writeln('Created by Nicholas, Versanis, Tim, Luke');
        multiple := 0;
        bitlengthdec := 0;
        decnumber := -1;
        bitlengthinput := 0;
      showwindow;
      while (bitlengthinput > 36) or (bitlengthinput < 4) do
        begin
          showwindow;
          writeln('     This program will convert a decimal number into its binary form.');
          textcolor(blue);
          writeln('--------------------------------------------------------------------------');
          textcolor(black);
          writeln('        Enter a bit length for the number you want to convert...');
          writeln('                (Factor of 4 up to and including 36)');
          talkwindow;
          readln(bitlengthinput);
          clrscr;
          showwindow;

          repeat
            multiple := multiple + 4;
            If multiple = bitlengthinput Then
              begin
                Goto Next;
              end;
          until multiple = 36;

          writeln('Invalid Number!!!');
          talkwindow;
          Readln;
          clrscr;
          showwindow;
          inputdecimal;
          exit;
        end;
Next:

      bitlength1 := bitlengthinput/2;

      while bitlength1 > 0 do
        if bitlengthdec = 0 then
          begin
            bitlengthdec := 16;
            bitlength1 := bitlength1 - 2;
          end
        else
          begin
            bitlengthdec := bitlengthdec * 4;
            bitlength1 := bitlength1 - 1;
          end;
      bitlengthdec2 := bitlengthdec - 1;
      while (decnumber < 0) or (decnumber > bitlengthdec2) do
        begin
          writeln('Input a whole number to convert to binary, up to ',bitlengthdec2:8:0,'...');
          talkwindow;
          readln(decnumber2);
          showwindow;
          decnumber := decnumber2;
        end
      end;



  procedure condectobin;
    begin
      binnumber := ' ';
      factor := bitlengthdec/2;
      while decnumber <> 0 do
        begin
          IF decnumber >= factor THEN
            begin
              decnumber := decnumber - factor;
              factor := factor / 2;
              binnumber := binnumber + '1';
            end
          ELSE
            begin
              binnumber := binnumber + '0';
              factor := factor / 2;
            end
        end;
      binlength := length(binnumber) - 1;
      while binlength < bitlengthinput do
        begin
          binnumber := binnumber + '0';
          binlength := length(binnumber) - 1;
        end
    end;


  procedure onescompliment;
    begin
      index := 2;
      comp1number[1] := ' ';

      repeat
        comp1number[index] := ' ';

        index := index +1;
      until index = 39;

      for x := 2 to length(binnumber) do
      begin
       if binnumber[x] = '0' then comp1number[x] := '1' else comp1number[x] := '0';
      end;

    end;
  procedure twoscompliment;
    begin
      index := length(binnumber);
      multvalue := 1;
      comp2numberdec := 0;
      repeat
        if comp1number[index] = '1' then
          begin
            comp2numberdec := comp2numberdec + multvalue;
          end;
        multvalue := multvalue * 2;
        index := index - 1;
      until index = 1
    end;
  procedure savefile;
    begin
      repeat
        writeln('What do you want to name your save file name? [8 Characters Max]');
        talkwindow;
        readln(filename);
        showwindow;
      until filename <> '';

      Writeln('Saving ',filename,'.txt...');
      assign(f, filename + '.txt');
      rewrite(f);
      write(f, 'Amount of nibblets - ');
      writeln(f, bitlengthinput/4:8:0);
      write(f, 'Number Selected to convert - ');
      writeln(f, decnumber2:8:0);
      write(f, 'Result of binary conversion - ');
      writeln(f, result1);
      write(f, 'Results compliment value - ');
      writeln(f, comp1number);
      write(f,'Results second compliment value - ');
      writeln(f, binnumber);
      close(f);
      writeln('File successfully saved as ',filename,'.txt, Press <Enter> to continue');
      talkwindow;
      readln;
      showwindow;
    end;


  procedure mainprogram;
    begin
      clrscr;
      inputdecimal;
      Condectobin;
      result1 := binnumber;
      onescompliment;

      twoscompliment;
      decnumber := comp2numberdec + 1;
      condectobin;
      writeln('The number ',decnumber2:8:0,' in binary is:');
      textcolor(green);
      writeln(result1);
      textcolor(black);
      writeln('This number`s ones compliment is:');
      textcolor(green);
      writeln(comp1number);
      textcolor(black);
      writeln('This number`s twos compliment is:');
      textcolor(green);
      writeln(binnumber);
      textcolor(black);
      writeln('Press <Enter> to continue.');
      talkwindow;
      readln;
      showwindow;
      repeat
        Writeln('Do you want to save results? [Y/N]');
        talkwindow;
        readln(saveQ);
        showwindow;
      until saveQ in ['n', 'y', 'N', 'Y'];

      saveQ := UPCASE(saveQ);

      IF saveQ = 'Y' then
      begin
        savefile;
      end;
    end;


  begin
    yesno := 'N';
    while yesno = 'N' do
      begin
        mainprogram;
        repeat
          writeln('Would you like to quit? (Y/N)');
          talkwindow;
          readln(yesno);
          clrscr;
          showwindow;
        until yesno in ['y','Y','n','N'];
        yesno := UPCASE(yesno);
        IF yesno = 'Y' then
          begin
            writeln('Bye! Hit <Enter> to quit');
            talkwindow;
            readln;
          end;
      end;
  end.