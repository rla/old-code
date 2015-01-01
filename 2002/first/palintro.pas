program palinroo;
                {tekst mis eest väi tagantpoolt annab sama tulemuse}
  var i,arv,arv1,arv2,k,b:longint;
begin
write('Sisesta arv ');
readln(arv);
arv1:=arv;
arv2:=arv;
k:=1;
b:=0;
for i:=1 to 10 do
  begin
  if arv mod 10 = 0 then arv:=arv mod 10
  else
    begin
    k:=10 * k;
    arv:=arv div 10;
    end;
  end;
while k>0 do
  begin
  b:=b+arv1 mod 10 * k;
  arv1:=arv1 div 10;
  k:=k div 10;
  end;
if b div 10 = arv2 then writeln('Arv ',arv2,' on palintroom')
else writeln('Arv ',arv2,' ei ole palinroom');
readln;
end.
