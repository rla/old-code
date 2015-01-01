program too9;
uses crt;
  var arv,arv2,max1,max2,max:longint;
         keskm:longint;
         fnimi1,fnimi2:string;
            ff,ff2:text;
             k,k2:longint;

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
writeln('Sisesta faili 1 nimi : ');
readln(fnimi1);
ftarvekr(fnimi1);
writeln('Sisesta faili 2 nimi : ');
readln(fnimi2);
ftarvekr(fnimi2);
assign(ff,fnimi1);
reset(ff);
readln;
assign(ff2,fnimi2);
reset(ff2);
readln(ff,arv);
max:=arv;
min:=arv;
k:=0;
l:=false;
reset(ff);
while not (eof(ff)) do
  begin
  readln(ff,arv);
  if arv>max then max:=arv;
  if arv<min then min:=arv;
  end;
while not (eof(ff2)) do
  begin
  readln(ff2,arv);
  if arv>max then
    begin
    max:=arv;
    l:=true;
    end;
  if arv<min then min:=arv;
  end;
if l then
  begin
  reset(ff2);
  k:=0;
  while arv<>max do
    begin
    readln(ff2,arv);
    k:=k+1;
    end;
  end
else
  begin
  reset(ff);
  k:=0;
  while arv<>max do
    begin
    readln(ff,arv);
    k:=k+1;
    end;
  end;
writeln('Suurim arv on ',max);
writeln('Väikseim arv on ',min);
writeln('Suurim on ',k,'. arv failis');
readln;
close(ff);
close(ff2);
end.