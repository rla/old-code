{program mis leiab esimesed sada algarvu}
program sadaalgarvu;
var arv,b,loend:longint;
onalg:boolean;
begin
onalg:=TRUE;
arv:=3;
loend:=0;
writeln('Esimesed sada algarvu on ');
write('2 ');
repeat
b:=3;
while b<=round(sqrt(arv)) do
  begin
    if arv mod b=0 then onalg:=FALSE;
    b:=b+2;
  end;
if onalg then
  begin
    write(arv,' ');
    loend:=loend+1;
  end;
arv:=arv+2;
until loend=100;
readln;
end.