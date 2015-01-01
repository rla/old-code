program akermani_funktsioon;
uses crt;
function ak(n:longint;m:longint):longint;
  begin
      if n>0 then ak:=ak(m+1,ak(m,n-1))
        else ak:=1;
  end;{figo}

var n:byte;

begin
clrscr;
write(ak(1,1));
readln;
for n:=1 to 100 do
  begin
    writeln(ak(n,n):15);
    if keypressed then exit;
  end;
readln;
end.