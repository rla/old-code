program new1;
uses crt;
            {leiab aritm keskmisele lähima arvu}
  var arv:longint;
  keskm:longint;
  fnimi:string;
  ff:text;
         k:byte;
         sum:real;
        vahe:longint;
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
k:=0;
sum:=0;
while not (eof(ff)) do
  begin
  readln(ff,arv);
  sum:=sum+arv;
  k:=k+1;
  end;
keskm:=round(sum/k);
writeln('Aritmeetiline keskmine on ',keskm:2);

reset(ff);
readln(ff,arv);
vahe:=abs(keskm-arv);
while not (eof(ff)) do
  begin
  readln(ff,arv);
  vahetmp:=abs(keskm-arv);
  if vahetmp < vahe then vahim:=arv;
  end;
writeln('Aritmeetilisele keskmisele on lähim arv ',vahim);
readln;
end.
