program KorrutamineLiitmisega;
                               {Kahe naturaalarvu x,y korrutis}
var x,y:integer;
    kor:longint;
      i:integer;
begin
write('x,y: ');
readln(x,y);
kor:=0;
for i:=1 to y do
kor:=kor+x;
writeln('Korrutis on ',kor);
readln;
end.