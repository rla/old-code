program too7;
uses crt;
var
ff1,ff:text;
fnimi:string;
arv:longint;
max:longint;
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
label lopp;
begin
clrscr;
write('Sisesta faili nimi : ');
readln(fnimi);
ftarvekr(fnimi);
assign(ff,fnimi);
reset(ff);
assign(ff1,'uusfail.art');
rewrite(ff1);
while not (eof(ff)) do
  begin
  readln(ff,arv);
  if arv < 0 then goto lopp;
  writeln(ff1,arv);
  end;
lopp:
close(ff1);
ftarvekr('uusfail.art');
assign(ff1,'uusfail.art');
reset(ff1);
readln(ff1,arv);
max:=arv;
while not (eof(ff1)) do
  begin
  readln(ff1,arv);
  if arv > max then max:=arv;
  end;
close(ff1);
writeln;
if max=0 then writeln('Arve polegi')
else writeln('Suurim on ',max);
readln;
end.