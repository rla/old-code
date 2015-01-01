program pyth;
uses crt;
var n,a,b,c,j:longint;
          d:boolean;
begin
clrscr;
b:=1;
for a:=1 to 100 do
  begin
  for b:=a to 100 do
    begin
    d:=TRUE;
    c:=round(sqrt(sqr(a)+sqr(b)));
    if sqr(c)=sqr(a)+sqr(b) then
      begin
      for j:=2 to round(a/2) do
        if (a mod j = 0) and (b mod j = 0) and (c mod j = 0) then d:=FALSE;
      if d then writeln(a,' ',b,' ',c);
      end;
    end;
  end;
readln;
end.