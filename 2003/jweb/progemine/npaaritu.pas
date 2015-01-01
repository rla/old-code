{program ,mis leiab esimese n-paarituarvu summa}

program npaaritu;
var n,sum,a:integer;
begin
writeln;
write('n: ');
readln(n);
sum:=0;
a:=1;
if n>0 then
   begin
     repeat
       n:=n-1;
       sum:=sum+a;
       a:=a+2;
     until n=0;
     writeln('n-paarituarvu summa on ',sum);
   end;
readln;
end.