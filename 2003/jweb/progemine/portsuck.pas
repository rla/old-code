program aaa;
uses crt;
  var prt:integer;
      aa:integer;
      ch:char;
begin
aa:=255;
prt:=100;
repeat
if keypressed then
  begin
  ch:=readkey;
  end;
port[prt]:=aa;
prt:=prt+1;
until ch=#27;
end.