program kolmekoharv; {kolega lõppev viiekohaline arv on täiskuup leida see arv jatema kuup ta on}
  var arv,i:longint;
  tulemus:longint;
  yh,kym,sj:integer;
begin
writeln;
arv:=100;{kuni 1000}
for i:=100 to 1000 do
  begin
    tulemus:=sqr(arv);
    yh:=tulemus mod 10;
    kym:=tulemus mod 100 div 10;
    sj:=tulemus mod 1000 div 100;
    if yh=0 then write
    else
    if yh=kym then
      if kym=sj then write(tulemus);
  end;
readln;
end.
