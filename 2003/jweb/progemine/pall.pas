program pall;
uses graph,crt;
  const
  d=15;
  var grm,grd,x,y,t,xx,yy:integer;
  ch:char;
  a,b:boolean;
begin
grd:=detect;
InitGraph(grd,grm,' ');
x:=300;
y:=200;
randomize;
xx:=1;
yy:=1;
repeat
{SetFillStyle(1,white);}
Circle(x,y,d);
rectangle(0,0,639,479);
{loodFill(x,y,15);      }
{SetFillStyle(1,black);}
{FloodFill(x,y,0);}
SetColor(GetBkColor);
Circle(x,y,d);
setColor(15);
x:=x+xx;
y:=y+yy;
if (x>=625) and not a then begin xx:=-xx; a:=true; end;
if (y>=465) and not b then begin yy:=-yy; b:=true; end;
if (x<=15) and a then begin xx:=-xx; a:=false; end;
if (y<=15) and b then begin yy:=-yy; b:=false; end;
if keypressed then ch:=readkey;
until ch=#27;
end.