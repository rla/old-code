program too15;
  uses crt;
  var jada:array[1..101] of integer;
  n,i:byte;
  max,min,maxtmp,mintmp,mink,maxk:integer;
begin
clrscr;
writeln('ARVUJADA(100 arvu)':40);
n:=1;
writeln('JADA : ');
repeat
jada[n]:=round(random*(100-300)+300);
write(jada[n]:8);
n:=n+1;
until n=101;
max:=0;
maxtmp:=4000;
min:=300;
mintmp:=-100;
writeln('Kaks kõige suuremat ');
for i:=1 to 2 do
  begin
  max:=0;
  for n:=1 to 100 do
    begin
      if (jada[n]>max) and (jada[n]<maxtmp) then max:=jada[n];
      if i=1 then maxk:=max;
      if (n=100) then begin writeln(max:4); maxtmp:=max; end;
    end;
  end;
writeln('Kaks kõige väiksemat ');
for i:=1 to 2 do
  begin
  min:=300;
  for n:=1 to 100 do
    begin
    if (jada[n]<min) and (jada[n]>mintmp) then min:=jada[n];
    if i=1 then mink:=min7;
    if n=100 then begin writeln(min:4); mintmp:=min; end;
    end;
  end;
writeln;
writeln;
for n:=1 to 100 do
begin
if jada[n]=max then writeln(max,' on ',n,'ndal kohal');
if jada[n]=maxk then writeln(maxk,' on ',n,'ndal kohal');
if jada[n]=min then writeln(min,' on ',n,'ndal kohal');
if jada[n]=mink then writeln(mink,' om ',n,'ndal kohal');
end;
readln;
end.