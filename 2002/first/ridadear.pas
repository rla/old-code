program ridade_arv;
uses crt;
  var arv,pikkus,kpikkus:integer;
  rida,fnimi:string;
  ridasid:integer;
  ff:text;
begin
clrscr;
write('Sisesta faili nimi : ');
readln(fnimi);
assign(ff,fnimi);
reset(ff);
writeln;
writeln('Faili ',fnimi,' sisu : ');
while not (eof(ff)) do
  begin
  readln(ff,rida);
  writeln(rida);
  end;
writeln('-----------------');
reset(ff);
ridasid:=0;
kpikkus:=0;
while not (eof(ff)) do
  begin
  readln(ff,rida);
  pikkus:=length(rida);
  kpikkus:=kpikkus+pikkus;
  write(rida);
  writeln(' - ':10,pikkus,' tähemärki');
  ridasid:=ridasid+1;
  end;
writeln('-----------------');
writeln('Kokku : ');
writeln(kpikkus,' tähemärki');
writeln(ridasid, ' rida');
writeln('Ühes reas keskmiselt ',kpikkus/ridasid:2:3,' tähemärki');
readln;
close(ff);
end.