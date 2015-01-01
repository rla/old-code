program seitsmes;
uses crt;


var   b:boolean;
      samples:real;
begin
samples:=1;
b:=false;
writeln;
repeat
gotoxy(1,25);
write(samples:0:0);
samples:=samples+1;
if keypressed then b:=true;
until b;
end.