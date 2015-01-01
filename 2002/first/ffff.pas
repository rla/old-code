program fff;
  var klnimi:string[3];
  klt:char;
begin
klt:='b';
klnimi:='10';
if length(klnimi)=1 then klnimi[2]:=klt
  else klnimi[3]:=klt;
klnimi[0]:=chr(ord(klnimi[0])+1);
write(klnimi);
end.