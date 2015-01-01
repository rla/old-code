program pii;
            {pi/4=1/(1+sqr(1)/(2+sqrt(3)/))}
uses crt;

function pi4(x:real): real;

  var s:real;
     se:real;
     rt,l:extended;
      i:extended;
      v:extended;
  begin
   i:=1000001;
   s:=1/2;
   l:=i*i+2;

   {v:=(i-2)/(2+sqr(i));
   i:=i-2;
   se:=v;
   i:=i-2;}
     repeat
       l:=i*i/l+2;
       i:=i-2;
     until i=1;

  l:=1+1/l;
  l:=4*1/l;
  pi4:=l;
end;{pi4}

begin
clrscr;
writeln(pi4(12));
readln;
end.