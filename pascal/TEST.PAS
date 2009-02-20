program Setitup;

type TSet = set of 1..10;
var
i : integer;
Numbers: Tset;

begin
Numbers := [3, 6, 8..10];
for i := 1 to 10 do
    begin
    if (i in Numbers) then
    begin
    writeln(i);
    end
    end;
    readln;
end.