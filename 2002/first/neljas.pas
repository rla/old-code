 program neljas;
                {ringi pindala ja ümbermõõdu leidja}
   var r:real;
 begin
 writeln;
 writeln('RINGI PINDALA JA ÜMBERMÕÕDU LEIDJA':50);
 writeln;
 writeln('Anna ringi raadius');
 readln(r);
 writeln('Ringi ümbermõõt on' ,(2*3.14*r));
 writeln('Ringi pindala on' ,(3.14*sqr(r)));
 readln;
 end.