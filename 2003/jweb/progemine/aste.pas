program ruut_;
uses crt;
{arv x astmes n = 1 kui n=0 ..=x*x*...x kui n>0 ..=1/(x astmel n) kui n<0}

function ruut(x,n:byte): longint;
  begin
  if n=0 then ruut:=1
    else ruut:=x*ruut(x,n-1);
  end;{ruut}

var x,n:byte;

begin
clrscr;
write('Sisesta arv '); readln(x);
write('Sisesta arvu aste '); readln(n);
writeln('Arv astmel n on ',ruut(x,n));
readln;
end.