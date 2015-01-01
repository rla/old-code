program ddd;
uses graph,crt;
const nurki=14;
  var hulknurk,hulknurk1,hulknurk2:array[1..20] of PointType;
  grd,dx,dy,i:integer;
  grm,a,b:integer;
  ch:char;
begin
grd:=detect;
InitGraph(grd,grm,' ');
dx:=0;
dy:=0;
hulknurk[1].x:=240;
hulknurk[1].y:=300;
hulknurk[2].x:=220;
hulknurk[2].y:=300;
hulknurk[3].x:=220;
hulknurk[3].y:=100;
hulknurk[4].x:=340;
hulknurk[4].y:=100;
hulknurk[5].x:=340;
hulknurk[5].y:=200;
hulknurk[6].x:=260;
hulknurk[6].y:=200;
hulknurk[7].x:=340;
hulknurk[7].y:=300;
hulknurk[8].x:=320;
hulknurk[8].y:=300;
hulknurk[9].x:=240;
hulknurk[9].y:=200;
hulknurk[10].x:=240;
hulknurk[10].y:=180;
hulknurk[11].x:=320;
hulknurk[11].y:=180;
hulknurk[12].x:=320;
hulknurk[12].y:=120;
hulknurk[13].x:=240;
hulknurk[13].y:=120;
hulknurk[14].x:=240;
hulknurk[14].y:=300;
drawpoly(nurki,hulknurk);
hulknurk2:=hulknurk;
repeat
hulknurk1:=hulknurk2;
if keypressed then
  begin
  ch:=readkey;
    case ch of
    #75:dx:=dx-3;
    #77:dx:=dx+3;
    #72:dy:=dy-3;
    #80:dy:=dy+3;
    end;
  for i:=1 to nurki do
    begin
    hulknurk2[i].x:=hulknurk[i].x+dx;
    hulknurk2[i].y:=hulknurk[i].y+dy;
    end;
  SetColor(getbkcolor);
  DrawPoly(nurki,hulknurk1);
  SetColor(15);
  Drawpoly(nurki,hulknurk2);
  setColor(getbkcolor);
  end;
until ch=#27;
end.