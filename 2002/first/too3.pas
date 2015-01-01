pro
gram


   too3;
var arvsis,oer,kymjag,i:integer;
begin
writeln('Sisesta kümme arvu');
oer:=0;
kymjag:=0;
for i:=1 to 10 do
  begin
    read(arvsis);
    if arvsis<>0 then oer:=oer+1;
    if arvsis mod 10 =0 then kymjag:=kymjag+1;
  end;
writeln;
  if kymjag>0 then writeln('Kümnega jaguvaid arve on ',kymjag)
  else writeln('Kümnega jaguvaid arve ei ole');
  if oer>0 then writeln('Nullist erinevaid arve on ',oer)
  else writeln('Nullist erinevaid arve ei ole');
readln;
readln;
end.