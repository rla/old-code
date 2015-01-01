program failiaritmkeskm;
uses crt;                       {täisarvudest koosnemava faili toomine kuvarile
                       ja aritm keskmise leidmine}
                       {new: leiab minimaalse posittiivsete hulgast,ja maks neg hulgast}
  var ff:text;
      ffneg:text;
      ffpos:text;
    tarv:longint;
   keskm:real;
   summa:longint;
    hulk:integer;
     min:longint;
     max:longint;
 mitmmin:integer;
 mitmmax:integer;
       a:integer;
       b:integer;
minposit:longint;
maxnegat:longint;
     tmp:longint;
   fnimi:string[15];
 jarjest:boolean;
begin
clrscr;
write('Lähteandmate faili nimi : ');
readln(fnimi);
writeln; writeln('Faili ',fnimi,' sisu :');
assign(ff,fnimi);
reset(ff);
summa:=0;
hulk:=0;
mitmmin:=0;
mitmmax:=0;
while not (eof(ff)) do
  begin
  readln(ff,tarv);
  write(tarv:10);
  end;
reset(ff);
writeln;
while not (eof(ff)) do
  begin
  readln(ff,tarv);
  summa:=summa + tarv;
  hulk:=hulk + 1;
  end;
reset(ff);
readln(ff,tarv);
min:=tarv;
max:=tarv;
reset(ff);
while not (eof(ff)) do
  begin
  readln(ff,tarv);
  if tarv < min then min:=tarv;
  if tarv > max then max:=tarv;
  end;
reset(ff);
while not (eof(ff)) do
  begin
  mitmmax:=mitmmax + 1;
  mitmmin:=mitmmin + 1;
  readln(ff,tarv);
  if tarv=max then a:=mitmmax;
  if tarv=min then b:=mitmmin;
  end;

reset(ff);
readln(ff,tarv);
maxnegat:=-2100000000;
minposit:=2100000000;
reset(ff);
while not (eof(ff)) do
  begin
  readln(ff,tarv);
  if (tarv < 0) and (tarv > maxnegat) then maxnegat:=tarv;
  if (tarv > 0) and (tarv < minposit) then minposit:=tarv;
  end;

reset(ff);
readln(ff,tarv);
tmp:=tarv;
jarjest:=TRUE;
while not (eof(ff)) and jarjest do
  begin
  readln(ff,tarv);
  if tarv<=tmp then jarjest:=FALSE;
  end;

{Lähtefailis olevad arvud paigutada kahte faili yhte negat teise posit}

writeln(tarv);
writeln('Suurim negatiivne arv : ',maxnegat);
writeln('Väikseim positiivne arv : ',minposit);
writeln('Suurim : ',max);
writeln('Väikseim : ',min);
writeln('Suurim arv on ',a,'. arv failis');
writeln('Väikseim arv on ',b,'. arv failis');
keskm:=summa/hulk;
writeln('Aritmeetiline keskmine : ',keskm:0:2);
if jarjest then writeln('Arvud on failis kasvavas järjekorras')
else writeln('Arvud ei ole failis kasvas järjekorras');
close(ff);
readln;
end.




