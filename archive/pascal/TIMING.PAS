program timing;
uses crt, Dos;

var
  h, m, s, hund : Word;
function LeadingZero(w : Word) : String;
var
  s : String;
begin
  Str(w:0,s);
  if Length(s) = 1 then
    s := '0' + s;
  LeadingZero := s;
end;
begin
  clrscr;
  GetTime(h,m,s,hund);
   if h > 12 then
begin
  h := h - 12;
end;
  Writeln('It is now ',LeadingZero(h),':',
          LeadingZero(m),':',LeadingZero(s),
          '.',LeadingZero(hund));
  readln;
end.
