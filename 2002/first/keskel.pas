program new1;
uses crt;
  var arv,arv2:longint;
  keskm:longint;
  fnimi:string;
  ff:text;
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
l:=false;
clrscr;
ftarvekr('laanemet.art');
{leab failist keskmisel kohal oleva arvu}
assign(ff,'laanemet.art');
reset(ff);
k:=0;
while not (eof(ff)) do
  begin
  readln(ff,arv);
  k:=k+1;
  end;
if (k mod 2) = 0 then l:=true;
k:=k div 2;
reset(ff);
repeat
  readln(ff,arv);
  k:=k-1;
until k=0;
if l then
  begin
  readln(ff,arv2);
  writeln('keskmisel kohal on ',arv,' ja ',arv2);
  end
else
  writeln('Keskmisel kohal olev arv on ',arv);
readln;
end.