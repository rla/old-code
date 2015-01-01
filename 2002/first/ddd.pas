program ddd;
uses graph,crt;
  var hulknurk:array[1..20] of PointType;
  grd,x,y:integer;
  grm,a,b:integer;
begin
grd:=detect;
InitGraph(grd,grm,' ');
a:=50;
b:=50;
repeat
hulknurk[1].x:=a+50;
hulknurk[1].y:=b;
hulknurk[2].x:=a;
hulknurk[2].y:=b+30;
hulknurk[3].x:=a+100;
hulknurk[3].y:=b+50;
hulknurk[4].x:=a+50;
hulknurk[4].y:=b;
SetColor(getbkcolor);
DrawPoly(4,hulknurk);
delay(10000);
SetColor(15);
DrawPoly(4,hulknurk);
a:=a+50;
until (a=600) or (b=400);
readln;
CloseGraph;
end.