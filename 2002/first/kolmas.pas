 program kolmas;
                {ristküliku pindala ja ümbermõõdu leidmise program}
   var a,b:real;
 begin
 writeln;
 writeln('RISTKÜLIKU ÜMBERMÕÕDU JA PINDALA LEIDJA':50);
 writeln;
 writeln('Anna ristküliku küljed');
 readln(a,b);
 writeln('ümbermõõt on ' , (2*(a+b)):5:2);
 writeln('pindala on ' , (a*b):5:2);
 readln;
 end.