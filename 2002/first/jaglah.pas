program jagmineLahutamisega;
  var v,u,j,jj:integer;
begin
write('u,v: ');
readln(u,v);
j:=0;
while u>=v do
  begin
  u:=u-v;
  j:=j+1;
  end;
jj:=v-u;
writeln('Jagatis on ',j);
writeln('Jääk on ',jj);
readln;
end.

