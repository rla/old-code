program new1;
uses crt;
            {leiab failis minimaalsele väärtusele eelneva arvu}
  var arv:longint;
  keskm:longint;
  fnimi:string;
  ff:text;
         k:integer;
         sum:real;
        min:longint;
        vahetmp:longint;
        vahim:longint;

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
writeln;
assign(ff,fnimi);
reset(ff);
readln(ff,arv);
min:=arv;
k:=0;
while not (eof(ff)) do
  begin
  readln(ff,arv);
  if arv < min then min:=arv;
  end;
reset(ff);
repeat
readln(ff,arv);
k:=k+1;
until arv=min;
k:=k-2;
if k<0 then writeln('Sellist arvu pole')
  else
  begin
  reset(ff);
  while k>=0 do
    begin
    readln(ff,arv);
    k:=k-1;
    end;
  writeln('Minimaalsele arvule eelnev arv on ',arv);
  end;
readln;
end.