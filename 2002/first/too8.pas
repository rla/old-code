program too8;
uses crt;
  var arv,arv2,narv:longint;
  keskm:longint;
  fnimi:string;
  ff,ff1,ff2:text;
         k:longint;
         sum:real;
        min:longint;
        vahetmp:longint;
        vahim:longint;
        l:boolean;

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
writeln('Sisesta faili nimi : ');
readln(fnimi);
ftarvekr(fnimi);
assign(ff,fnimi);
reset(ff);
assign(ff1,'paarisarv.art');
rewrite(ff1);
assign(ff2,'paaritud.art');
rewrite(ff2);
writeln;
writeln('Uued arvud : ');
while not (eof(ff)) do
  begin
  readln(ff,arv);
  narv:=arv div 10;
  write(narv:10);
  if (narv mod 2) = 0 then writeln(ff1,narv)
    else writeln(ff2,sqr(narv));
  end;
close(ff1);
close(ff2);
writeln;
ftarvekr('paarisarv.art');
writeln;
ftarvekr('paaritud.art');
readln;
end.