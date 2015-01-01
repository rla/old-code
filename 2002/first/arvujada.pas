program arvujada;
       {arvujada ümberpöörata,arvujada tsükliline nihutamine i kohta}
uses crt;

const n=9;
      jada:array[1..n] of integer = (2,-4,13,5,-7,21,14,3,-1);

var
      ch:char;
      m:integer;
      n,i:byte;
begin
repeat
writeln('<1>   Pööra ümber');
writeln('<2>   Nihuta i kohta');
writeln('<ESC> Väljumine');
ch:=readkey;
case ch of
  '1':begin
      clrscr;
      writeln();
      redln;
      end;
  '2':begin
      end;
end;{case lõpp}
until ch=#27;
end.