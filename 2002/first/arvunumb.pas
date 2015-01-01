 program numbrid;
                           {arvu numbrite leidmine}
   var x,x1,x2:integer;
 begin
 writeln;
 writeln('Anna kahekohaline arv');
 readln(x);
 x1:=x mod 10;
 x2:=x div 10;
 writeln('Ühelised ',x1);
 writeln('Kümnelised ',x2);
 readln;
 end.