 program sinus;
uses crt;
var k,l:integer;
x:real;
function sinx(x:real) : real;
  const
    pii2=2*PI;
    eps=0.5E-12;
  var
    r,s,l,se,t,nurk:real;
    i,a:integer;
  begin
    x:=frac(x/pii2)*pii2;
    r:=x*x;
    s:=0;
    l:=x;
    i:=2;
    repeat
      se:=s;
      s:=s+l;
      l:=-l*r/(i*(i+1));
      i:=i+2;
    until abs(s-se)<eps;
    sinx:=s;
  end;{sinx}

begin
clrscr;
l:=30;
write('nurk':4); write('sinx':30); writeln('sin':30); writeln;
for k:=1 to 22 do
  begin
  write(l:4);
  x:=l/180*PI;
  write(sinx(x):30);
  writeln(sin(x):30);
  l:=l+360;
  end;
readln;
end.