program too_12;
  uses graph,crt;
  const r=10;
  var x,y,xa,xb,grd,grm:integer;
  ch:char;
  ed:boolean;
begin
grd:=detect;
InitGraph(grd,grm,' ');
ed:=true;
x:=120;
y:=260;
repeat
SetColor(15);
Rectangle(x+10,y-10,x-60,y-40);
Circle(x,y,r);
Circle(x-50,y,r);
if ed then Rectangle(x+8,y-20,x,y-38)
  else Rectangle(x-58,y-20,x-50,y-38);
delay(300);
SetColor(GetBkColor);
Circle(x,y,r);
Circle(x-50,y,r);
Rectangle(x+10,y-10,x-60,y-40);
if ed then Rectangle(x+8,y-20,x,y-38)
  else Rectangle(x-58,y-20,x-50,y-38);
if keypressed then ch:=readkey;
if ed then x:=x+3
  else x:=x-3;
if x>640 then ed:=false;
if x<50 then ed:=true;
until ch=#27;
CloseGraph;
end.