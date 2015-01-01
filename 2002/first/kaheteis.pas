program kaheteistkymnes;
  var arv,a,divr:integer;
begin
writeln;
write('Sisesta arv: ');
readln(arv);
divr:=1;
a:=100;
while a>=10 do
  begin
    a:=arv div divr;
    divr:=10*divr;
  end;
if arv mod 10 = a then writeln('Sisestatud arv algab ja läpeb sama arvuga')
else writeln('Sisestatud arv ei alga ja läpe sama arvuga');
readln;
end.