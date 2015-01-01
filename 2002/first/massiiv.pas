program massiiv;
uses crt;
  var tabel:array[1..10,1..10] of integer;
      i,j,k:integer;
begin
clrscr;
i:=10;
k:=1;
while i>0 do
  begin
  for j:=1 to i do begin tabel[i,j]:=k; k:=k+1; end;
  i:=i-1;
  end;
readln;
for i:=1 to 10 do
  for j:=1 to 10 do
    if j<>10 then write(tabel[11-i,j]:3)
    else writeln(tabel[11-i,j]:3);
readln;
end.