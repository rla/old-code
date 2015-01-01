program neljateistkymnes;
                         {1.leida naturaalarvud mis suuremevad kämme
                         korda kui nende kirjapildis üheliste ja
                         kümneliste vahele lisada null.
                          2.leida kolmekohaline arv, mille ruut lõppeb
                          kolme ühesuguse nulliga mittevõrduva arvuga}
  var arv,kym,yh,narv:integer;
begin
writeln;
arv:=10;
while arv<100 do
  begin
    kym:=arv div 10;
    yh:=arv mod 10;
    narv:=100 * kym + yh;
    if narv / arv = 10 then write(arv,' ');
    arv:=arv+1;
  end;
readln;
end.

