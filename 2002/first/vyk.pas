program vyk;
  var arv1,arv2,arv1a,arv2b:integer;
begin
writeln;
write('Sisesta kaks arvu: ');
readln(arv1,arv2);
arv1a:=arv1;
arv2b:=arv2;
while arv1<>arv2 do
  begin
  if arv1<arv2 then arv1:=arv1+arv1a;
  if arv2<arv1 then arv2:=arv2+arv2b;
  end;
writeln('Väikseim ühiskordne on ',arv1);
readln;
end.
                            {2.kontrollib kas sisestatud arv algab ja lõpeb ühe ja sama numbriga}
