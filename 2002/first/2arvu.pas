program arvu;
              {sisteta 2 arvu,lahuta, tulemuse üheliste number nii mitu korda väljasta tuleb}
var arv1,arv2,tulemus,yhnum,i:longint;
begin
writeln;
write('Sisesta kaks arvu: ');
readln(arv1,arv2);
{arvutused:}
tulemus:=arv1-arv2;
yhnum:=tulemus mod 10;
if yhnum<0 then yhnum:=-yhnum;
for i:=1 to yhnum do
writeln(arv1,'-',arv2,'=',tulemus);
readln;
end.