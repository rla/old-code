program liikuv_k;
uses graph,crt;
  var x,y,grd,grm,xx,yy:integer;
       ch:char;
begin
grd:=detect;
InitGraph(grd,grm,' ');
ch:=' ';
x:=320;
Y:=240;
setbkcolor(0);
SetFillStyle(1,white);
Circle(x,y,10);
Floodfill(x,y,white);
repeat
xx:=x;
yy:=y;
if keypressed then
  begin
  ch:=readkey;
    case ch of
    #75:x:=x-3;
    #77:x:=x+3;
    #72:y:=y-3;
    #80:y:=y+3;
    end;
  SetColor(GetBkColor);
  Circle(xx,yy,10);
  SetColor(white);
  Circle(x,y,10);
  Floodfill(x,y,white);
  end;
until ch=#27;
CloseGraph;
end.
