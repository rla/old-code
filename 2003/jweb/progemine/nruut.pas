program nruut;
uses crt;

function ruut(n:integer): longint;
  begin
  if n=0 then ruut:=0
    else ruut:=2*n-1+ruut(n-1);
  end;{ruut}

begin
clrscr;
writeln(ruut(3));
readln;
end.