program ringruut;
uses crt,graph;
  var
  grd,grm:integer;
  d,a,b,x,y:real;
begin
grd:=detect;
InitGraph(grd,grm,' ');
x:=70;
y:=70;
a:=470;
b:=470;
d:=235;
repeat
SetColor(15);
Rectangle(round(x),round(y),round(a),round(b));
Circle(320,240,round(d));

until d<=0;
readln;

end.