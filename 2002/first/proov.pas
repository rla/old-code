program proov;
uses crt;
var arv,sobarv,jag,loend,arv2:longint;
begin
clrscr;
arv:=3;
sobarv:=0;
loend:=0;
repeat
sobarv:=1;
arv2:=1;
  for jag:=2 to round(sqrt(arv)) do
  if arv mod jag = 0 then sobarv:=sobarv+jag+arv div jag;

  for jag:=2 to round(sqrt(sobarv)) do
  if sobarv mod jag = 0 then arv2:=arv2+jag+sobarv div jag;

if arv=arv2 then
begin
writeln(arv,' ja  ',sobarv);
end;
arv:=arv+1;
loend:=loend+1;
until arv>1000000;
readln;
close(tfail);
end.