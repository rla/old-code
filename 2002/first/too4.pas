program too4;
uses crt;
var arv1,arv2,suurem,i,vaiksem:integer;
begin
clrscr;
writeln('Sisesta kaks arvu');
read(arv1,arv2);
if arv1>arv2 then
  begin
    suurem:=arv1;
    vaiksem:=arv2;
  end
else
  begin
    suurem:=arv2;
    vaiksem:=arv1;
  end;
writeln;
for i:=1 to suurem mod 10 do
  write(suurem,' ');
writeln;
writeln;
while suurem>=vaiksem do
  begin
    writeln(suurem,'-',vaiksem,'=',suurem-vaiksem);
    suurem:=suurem-vaiksem;
  end;
readln;
readln;
end.

