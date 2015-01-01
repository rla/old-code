program margitabel;
uses crt;
  var m:byte;
begin
clrscr;
for m:=0 to 255 do
  begin
  write(chr(m):3);
  end;
readln;
end.