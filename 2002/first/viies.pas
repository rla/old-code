 program viies;
              {minu viies programm}
   var x,x2,x3,rjx:real;
 begin
 writeln;
 writeln('ARVUTUSED');
 writeln;
 writeln('x=');
 readln(x);
 x2:=sqr(x);
 x3:=x2*x;
 rjx:=sqrt(x);
 writeln('x2=' ,x2:6:2);
 writeln('x3=' ,x3:6:2);
 writeln('2x3-3x2+rjx=' ,2*x3-3*x2+rjx:6:2);
 readln;
 end.