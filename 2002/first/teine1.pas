 program teine;
              {lihtne ruutvõrrandi lahendaja}

    var a,b,c,d:real;

 begin
 writeln;
 writeln('LIHTNE RUUTVÕRRANDI LAHENDAJA':50);
 write('Palun kordajad a b c: ');
 readln(a,b,c);
 d:=sqr(b)-4*a*c;
 if a<>0 then
   begin
     if d>=0 then
       begin
       writeln('x1 =' ,(-b+sqrt(d))/(2*a):5:2);
       writeln('x2 =' ,(-b-sqrt(d))/(2*a):5:2);
       end
     else
       writeln('Reaalsed lahendid puuduvad');
   end
 else writeln('Ei ole ruutvõrrand!!!');
 readln;
 end.