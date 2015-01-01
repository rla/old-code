program new;
           {programm leiab lähtefailis min ja max väärtuse ning aritm keskm ja seejaärel
          seejärel kõik arvud mis jäävad aritm keskm ja miinimumi vahele kirjutatakse ühte
          ja ülejäänud teise }

  uses crt;

  var
     ff1:text;
     ff2:text;
      ff:text;
     arv:longint;
   fnimi:string;
     min:longint;
     max:longint;
   summa:real;
       k:integer;
   keskm:real;

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
assign(ff1,'fneg.art');
rewrite(ff1);
assign(ff2,'fpos.art');
rewrite(ff2);

clrscr;
write('Sisesta faili nimi : ');
readln(fnimi);
ftarvekr(fnimi);
assign(ff,fnimi);
writeln;

reset(ff);
summa:=0;
k:=0;
while not (eof(ff)) do
  begin
  readln(ff,arv);
  summa:=summa+arv;
  k:=k+1;
  end;
keskm:=summa/k;
writeln('Aritmeetiline keskmine on ',keskm:2:0);

reset(ff);
readln(ff,arv);
min:=arv;
max:=arv;
while not (eof(ff)) do
  begin
  readln(ff,arv);
  if arv < min then min:=arv;
  if arv > max then max:=arv;
  end;

reset(ff);
while not (eof(ff)) do
  begin
  readln(ff,arv);
  if arv < keskm then writeln(ff1,arv)
  else writeln(ff2,arv);
  end;

close(ff1);
close(ff2);
ftarvekr('fpos.art');
ftarvekr('fneg.art');
readln;
end.
