program veerg;
        {kahemõõtmelises massiivis väikseima summaga veeru leidmine,arvud failis}
const ridu=5;
     veerge=10;
     fnimi='gen.ttr';
var jarjend:array[1..ridu,1..veerge] of integer;
    ff:text;
    r,v,minv:byte;
    sum,min:integer;
begin
assign(ff,fnimi);
reset(ff);
for r:=1 to ridu do
  for v:=1 to veerge do
    readln(ff,jarjend[r,v]);
close(ff);
sum:=0;
for r:=1 to ridu do
  sum:=sum+jarjend[r,1];
min:=sum;
minv:=1;
for v:=2 to veerge do
  begin
  sum:=0;
  for r:=1 to ridu do
    sum:=sum+jarjend[r,v];
  if sum<min then
    begin
    min:=sum;
    minv:=v;
    end;
  end;
end.