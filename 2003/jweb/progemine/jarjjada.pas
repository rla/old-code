program jarjestamine;
uses crt;
  const n=480;
  var jada:array[1..n] of integer;
      i,j,abi:integer;
begin
clrscr;
randomize;
for i:=1 to n do
  jada[i]:=integer(random(1998))-999;
for i:=2 to n do
  for j:=n downto i do
    if jada[j]<jada[j-1] then
      begin
      abi:=jada[j-1];
      jada[j-1]:=jada[j];
      jada[j]:=abi;
      end;
for i:=1 to 256 do
  write(chr(i));
readln;
end.