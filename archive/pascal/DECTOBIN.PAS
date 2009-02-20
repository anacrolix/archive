program DecimalToBinary;
  uses crt;
  var
    decnumber: real;
    decnumber2: integer;
    binnumber: string;
    factor: real;
    binlength: integer;
  procedure inputdecimal;
    begin
      clrscr;
      decnumber := -1;
      while (decnumber > 255) or (decnumber < 0) do
        begin
          writeln('Input a whole number to convert to binary, up to 255...');
          readln(decnumber2);
          decnumber := decnumber2;
        end
    end;
  procedure condectobin;
    begin
      binnumber := '';
      factor := 128;
      clrscr;
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
      binlength := length(binnumber);
      while binlength < 8 do
        begin
          binnumber := binnumber + '0';
          binlength := length(binnumber);
        end
    end;
  begin
    clrscr;
    inputdecimal;
    Condectobin;
    clrscr;
    writeln('The number ',decnumber2,' in binary is:');
    writeln(binnumber);
    readln;

  end.