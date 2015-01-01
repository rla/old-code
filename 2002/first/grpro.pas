program grpro;
  uses graph;
  var grd,grm:integer;
  i:byte;
  a:word;
begin
grd:=detect;
InitGraph(grd,grm,' ');
SetFillStyle(1,15);

Circle(320,350,60);
Circle(320,250,40);
Circle(320,180,30);
Circle(370,250,10);
Circle(270,250,10);
Circle(310,170,2);
Circle(330,170,2);
Floodfill(320,180,15);
Floodfill(320,244,15);
FloodFill(320,350,15);
Floodfill(370,170,15);
FloodFill(270,170,15);
a:=350;
SetColor(2);
for i:=1 to 6 do
  begin
  a:=a-20;
  Circle(320,a,2);
  FloodFill(320,a,2);
  end;
Line(300,150,340,150);
SetColor(15);
Rectangle(310,120,330,150);
readln;
end.