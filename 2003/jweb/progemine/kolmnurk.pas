 program kolmnurk;
                  {kolmnurga täisnurksuse kontrollimine}
   var a,b,c:integer;
 begin
 writeln;
 write('Kolmnurga küljed: ');
 readln(a,b,c);
   if a+b<=c then writeln('Kolmnurka ei moodustu');
   if a+c<=b then writeln('Kolmnurka ei moodustu');
   if b+c<=a then writeln('Kolmnurka ei moodustu');
   if sqr(a)+sqr(b)=sqr(c) then writeln('Kolmnurk on täisnurkne');
   if sqr(c)-sqr(a)=sqr(b) then writeln('Kolmnurk on täisnurkne');
   if sqr(c)-sqr(b)=sqr(a) then writeln('kolmnurk on täisnurkne');
 readln;
 end.
