{kahte arvu nimitatakse sõbralikuks kui ühe kõigi jagajate
summa v.a. arv ise summa võrdub teise arvuga ja vastupidi}
program sobralikudarvud;
var arv,sobarv,i,jag:integer;
begin
arv:=2;
sobarv:=2;
repeat
  begin
  jag:=1;
  while jag<round(sqrt(arv)) do
    begin
    if arv mod jag = 0 then sobarv:=sobarv+jag+sobarv div jag;
    jag:=jag+1;
    end;
  writeln(arv,' ',sobarv);
  arv:=arv+1;
  end;
until sobarv>1000;
readln;
end.