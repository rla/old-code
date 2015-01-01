program new2;
             {genereerib n täisarvu lõigul a b-ni ja kirjutab faili}
uses crt;
  var n:integer;
     ff:text;
     arv,a,b:longint;
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
writeln('Genereerib n täisarvu lõigul a-st b-ni');
write('Sisesta n : ');
readln(n);
write('Sisesta lõik ab : ');
readln(a,b);
write('Sisesta faili nimi : ');
readln(fnimi);
assign(ff,fnimi);
rewrite(ff);
while n>=0 do
  begin
  arv:=round(random*(b-a)+a);
  writeln(ff,arv);
  n:=n-1;
  end;
close(ff);
ftarvekr(fnimi);
readln;
end.