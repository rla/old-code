program ristsumma;
                  {leiab arvu ristsumma}
var arv,rists,a:integer;
begin
write('Arv: ');
readln(arv);
rists:=0;
while arv>0 do
  begin
    a:=arv mod 10;
    arv:=arv div 10;
    rists:=rists+a;
  end;
writeln('Arvu ristsumma on ',rists);
readln;
end.

