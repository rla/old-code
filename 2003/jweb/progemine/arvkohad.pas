program taiarvk;
                {mitmekohaline on täisarv}
  var arv,koh:integer;
begin
write('Arv: ');
readln(arv);
koh:=0;
while arv>0 do
  begin
  arv:=arv div 10;
  koh:=koh+1;
  end;
writeln('Arvul on ',koh,' kohta');
readln;
end.