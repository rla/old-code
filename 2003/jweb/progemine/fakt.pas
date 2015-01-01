program faktioriaal;
uses crt;

function fakt(n:byte):longint;
  begin
    if n>0 then fakt:=fakt(n-1)*n
    else fakt:=1;
end;{fakt}

var n:byte;

begin
clrscr;
writeln('Arv','Faktoriaal':18);
for n:=0 to 12 do
  begin
    write(n:2,'!  =');
    writeln(fakt(n):15);
  end;
readln;
end.