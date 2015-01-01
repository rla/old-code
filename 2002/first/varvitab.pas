program varvitabel;
uses crt;
  var v:integer;
begin
clrscr;
for v:=1 to 7 do
begin
textbackground(v);
writeln('Text');
end;
readln;
end.