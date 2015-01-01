program algtegurid;
var arv,a,b:integer;

begin
write('Arv: ');
readln(arv);
b:=2;
writeln('Arvu algtegurid on ');
while arv>=b do
  begin
    while (arv mod b)=0 do
      begin
        write(b,' ');
        arv:=arv div b;
      end;
    b:=b+1;
  end;
readln;
end.
