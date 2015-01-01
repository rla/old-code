program failiaritmkeskm;
uses crt;                       {täisarvudest koosnemava faili toomine kuvarile
                       ja aritm keskmise leidmine}
  var ff:text;
    tarv:longint;
   keskm:real;
   summa:longint;
    hulk:integer;
   fnimi:string[15];
begin
clrscr;
fnimi:='pro.art';
writeln; writeln('Faili ',fnimi,' sisu :');
assign(ff,fnimi);
reset(ff);
summa:=0;
hulk:=0;
while not (eof(ff)) do
  begin
  readln(ff,tarv);
  write(tarv:10);
  end;
reset(ff);
writeln;
write('Kolmega jaguvad :');
while not (eof(ff)) do
  begin
  readln(ff,tarv);
  summa:=summa + tarv;
  hulk:=hulk + 1;
  end;
reset(ff);
while not (aof(ff)) do
  begin
  readln(ff,tarv);
  end;
keskm:=summa/hulk;
writeln;
writeln('Aritmeetiline keskmine : ',keskm:0:2);
close(ff);
readln;
end.




