program nimevahetaja;
  var nimi,ees:string;
  a,b,c,d:integer;
begin
write('Sisesta oma nimi : ');
readln(nimi);
a:=pos(' ',nimi);
b:=length(nimi);
c:=0;
d:=a;
repeat
write(nimi[a]);
a:=a+1;
until b=a;
write(' ');
repeat
write(nimi[c]);
c:=c+1;
until c=d;
readln;
end.