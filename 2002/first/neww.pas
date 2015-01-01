program neww;
  var ch:char;
  lause:string[80];
begin
lause:='esimene täht viimaseks';
ch:=lause[1];
lause[1]:=lause[length(lause)];
lause[length(lause)]:=ch;
writeln(lause);
readln;
end.