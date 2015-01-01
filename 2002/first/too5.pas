program too5;
uses crt;
var arv,min,max:longint;
ff,ff1,ff2:text;
sn:longint;
vn,i:longint;
a:longint;
fnimi:string;
procedure ftarvekr(fnimi:string);
    var arv:longint;
         ff:text;
  begin
  assign(ff,fnimi);
  reset(ff);
  writeln;
  writeln('Faili ',fnimi,' sisu:');
  while not (eof(ff)) do
    begin
    readln(ff,arv);
    write(arv:10);
    end;
  close(ff);
  writeln;
  end;{ftarvekr}
begin
clrscr;
assign(ff1,'suurim.art');
rewrite(ff1);
assign(ff2,'väikseim.art');
rewrite(ff2);
write('Sisesta faili nimi : ');
readln(fnimi);
ftarvekr(fnimi);
assign(ff,fnimi);
reset(ff);
readln(ff,arv);
min:=arv;
max:=arv;
while not (eof(ff)) do
  begin
  readln(ff,arv);
  if arv > max then max:=arv;
  if arv < min then min:=arv;
  end;
writeln;
writeln('Suurim arv on ',max);
writeln('Väikseim arv on ',min);

a:=1000000000;
sn:=0;
for i:=1 to 10 do
  begin
  arv:=(max div a) mod 10;
  if arv > sn then sn:=arv;
  a:=a div 10;
  end;

a:=1000000000;
vn:=9;
for i:=1 to 10 do
  begin
  arv:=(min div a) mod 10;
  if (arv < vn) and (arv<>0) then vn:=arv;
  a:=a div 10;
  end;
write(ff1,sn);
write(ff2,vn);
close(ff2);
close(ff1);
ftarvekr('suurim.art');
ftarvekr('väikseim.art');
readln;
end.