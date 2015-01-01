program too10;
uses crt;
  var lause:string;
          l,a,b:byte;
       ptrm:boolean;
begin
clrscr;
ptrm:=true;
writeln('Sisesta lause');
readln(lause);
l:=length(lause) div 2;
a:=1;
b:=length(lause);
if b=1 then writeln('Lause on palindroom')
  else
  begin
repeat
if lause[a]<>lause[b] then ptrm:=false;
a:=a+1;
b:=b-1;
l:=l-1;
until l=0;
if ptrm then writeln('Lause on palindroom')
  else writeln('Lause pole palindroom');
end;
readln;
end.