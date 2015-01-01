program abSYT;{mitmekohaline on täisarv leia ristsumm leia kahe naturaalarvu ühistegur
süt a,b =}
var a,b:integer;

begin
writeln;
write('a,b: ');
readln(a,b);
if a>0 then
  if b>0 then
    begin
repeat
if a>b then
a:=a-b;
if a<b then
b:=b-a;
until a=b;
writeln(' SÜT on ',a);
readln;
    end;
end.
