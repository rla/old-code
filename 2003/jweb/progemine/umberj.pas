program rekurs5;
uses crt;

type string10=string[10];

function del(s:string;i:integer;c:integer):string ;
  begin
  delete(s,i,c);
  del:=s;
end;{del}

procedure strng(sona:string10; n:byte);
  var muudetud:string[10];
      i:byte;
      pik:byte;
      ch:char;
  begin
  muudetud:=sona;
  pik:=length(sona);
  i:=n;
  if pik=1 then writeln(sona);
  if n<pik then
  repeat
    ch:=muudetud[n];
    muudetud[n]:=muudetud[i];
    muudetud[i]:=ch;
    i:=i+1;
    if n>pik-2 then writeln(muudetud);
    strng(muudetud,n+1);
  until i>pik
end;{strng}

var sona:string;

begin
clrscr;
write('Sisesta säna: '); readln(sona);
strng(sona,1);
readln;
end.