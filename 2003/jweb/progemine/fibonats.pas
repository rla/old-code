program figonassi_arv;
uses crt;
function fibo(n:longint):longint;
  begin
      if n>0 then fibo:=fibo(n-1)+fibo(n-2)
        else fibo:=1;
  end;{figo}

var n:byte;

begin
clrscr;
for n:=1 to 100 do
  begin
    write('F',n,'=');
    writeln(fibo(n):15);
    if keypressed then exit;
  end;
readln;
end.