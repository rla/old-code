program too2;
{leiab kahest arvust suurema ja vljastab seda
niipalju kordi kui on ta _heliste number.leiab
suurema arvu paarisarvuliste numbrite arvu}

var i,paararv,yhnum:integer;
b:boolean;
divr,arv1,arv2,a,suurem:longint;

begin
writeln('Sisesta kaks arvu');
readln(arv1,arv2);

if arv1>arv2 then
suurem:=arv1
else suurem:=arv2;

yhnum:=suurem mod 10;
for i:=1 to yhnum do
write(suurem{,' '});

divr:=1000000000;
paararv:=0;
b:=FALSE;






repeat
a:=suurem div divr;
if a>1 then
begin
b:=TRUE;
a:=a mod 10;
case a of
2,4,6,8:paararv:=paararv+1;
end;
end;
if a=0 then
if b=TRUE then paararv:=paararv+1;
divr:=divr div 10;
until divr=0;


writeln;
writeln('Suuremas arvus on ',paararv,' paarisarvulist numbrit');
readln;

end.
