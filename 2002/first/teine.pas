 program teine;
              {lihtne ruutvõrrandi lahendaja}
    var a,b,c:real;
 begin
 writeln;
 writeln('LIHTNE RUUTVÕRRANDI LAHENDAJA':50);
 write('Palun kordajad a b c: ');
 readln(a,b,c);
 writeln('x1 =' ,(-b+sqrt(sqr(b)-4*a*c))/(2*a):5:2);
 writeln('x2 =' ,(-b-sqrt(sqr(b)-4*a*c))/(2*a):5:2);
 readln;
 end.