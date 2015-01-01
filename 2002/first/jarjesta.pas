program new2;
             {paigutab arvud uude faili kasvavas järjekorras}
uses crt;

  const uusfail='uus.art';

  var n:integer;
     ff,ff1:text;
     arv,a,b,min,min2:longint;
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
write('Sisesta faili nimi : ');
readln(fnimi);
ftarvekr(fnimi);

assign(ff,fnimi);
reset(ff);

assign(ff1,uusfail);
rewrite(ff1);

readln(ff,arv);
min:=arv;
a:=0;
while not (eof(ff)) do
  begin
  n:=0;
  a:=a+1;
  readln(ff,arv);
  if arv<min then
    begin
    min:=arv;
    n:=1;
    end;
  end;
writeln(ff1,min);
reset(ff);
while not (eof(ff)) do
  begin
  readln(ff,arv);
  if arv=min then
    begin
    if n>=2 then writeln(ff1,arv);
    n:=n+1;
    end;
  end;
reset(ff);
while a>0 do
  begin
  reset(ff);
  min2:=1000000;
  while not (eof(ff)) do
    begin
    readln(ff,arv);
    if (arv<min2) and (arv>min) then min2:=arv;
    end;
    {---}
  reset(ff);
  n:=1;
  while not (eof(ff)) do
    begin
    readln(ff,arv);
    if arv=min2 then
      begin
      writeln(ff1,arv);
      n:=n+1;
      end;
    end;
    {---}
  min:=min2;
  while n>=0 do
    begin
    if min2<>1000000 then writeln(ff1,min2);
    n:=n-1;
    end;
  a:=a-1;
  end;
close(ff);
close(ff1);
ftarvekr(uusfail);
readln;
end.