program e_x;
uses crt;
function ex(x:real) : real;
  const e=2.71828182845904523560287;
  var tmp:real;
      s,l,se,t,kontr:real;
      k,i:longint;
  begin
  s:=0;
  kontr:=int(x);
  {if kontr<>0 then
    begin
    tmp:=e
    end
  else
    begin
    tmp:=0
    end;}
  k:=1;
  tmp:=1;
  while k<=kontr do
    begin
      tmp:=tmp*e;
      k:=k+1;
    end;
  x:=frac(x);
  s:=0;
  l:=1;
  i:=1;
  if x<>0 then
    begin
      repeat
        se:=s;
        s:=s+l;
        l:=l*x/i;
        i:=i+1;
      until abs(s-se)<0.5E-12;
    end;
  if s=0 then
    ex:=tmp
  else
    ex:=s*tmp;
end;{ex}
var s:real;
begin
clrscr;
write('Sisesta arv :'); readln(s); write(' ');
writeln('Ex(',s,')=',ex(s)); writeln('Exp(',s,')=',exp(s));
readln;

end.
