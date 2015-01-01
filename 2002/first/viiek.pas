program viiek;
uses crt;
var arv,a:longint;
begin
clrscr;
a:=0;
while arv<1000000 do
begin
   arv:=a*a*a;
    if arv mod 10 = 3 then
    if arv >100000 then writeln(arv,' ',a);
a:=a+1;
end;
readln;
end.


