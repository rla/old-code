program arvud;
              {sisesta kaks arvu, väljasta suuremat ähele reale nii mitu korda
              kui suur on selle arvu yheliste arv}
var arv1,arv2,suurem,yhnum,paararv,i,a,divr:longint;
begin
writeln;
write('Sisesta kaks arvu: ');
readln(arv1,arv2);
if arv1>arv2 then suurem:=arv1
else suurem:=arv2;
paararv:=0;
divr:=1;
yhnum:=suurem mod 10;
begin
     for i:=1 to yhnum do
     write(suurem,' ');
     end;
a:=suurem div 10 mod 10;{kymnelised}
case a of
2,4,6,8,0:paararv:=paararv+1;
end;
a:=suurem mod 10;{yhelised}
case a of
2,4,6,8,0:paararv:=paararv+1;
end;
a:=suurem div 100 mod 10;
case a of
2,4,6,8,0:paararv:=paararv+1;
end;
writeln;
writeln('Suuremas arvus on ',paararv,' paarisarvulist numbrit');
readln;
end.


