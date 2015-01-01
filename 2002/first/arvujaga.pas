
program arvujagajad;
  var arv,a,b:integer;
begin
write('Arv: ');
readln(arv);
write('Arvu jagajad on ');
b:=1;
repeat
  a:=arv mod b;
  if a=0 then write(b,' ');
  b:=b+1;
until b=arv;
readln;
end.