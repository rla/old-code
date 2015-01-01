program ridad;
uses crt;
	var lause:string;
				esim,teine:char;
				i,sonarv:byte;
begin
clrscr;
write('Sisesta lause : ');
readln(lause);

esim:=' ';
for i:=1 to length(lause) do
	begin
	teine:=lause[i];
	if (teine=esim) and (teine=' ') then
		begin
		delete(lause,i,1);
		i:=i-1;
		end;
		esim:=teine;
	end;

sonarv:=0;
for i:=1 to length(lause) do
	begin
	teine:=lause[i];
	if teine=' ' then inc(sonarv);
	end;

writeln('---------------');

for i:=1 to sonarv do
	begin
	writeln(copy(lause,1,pos(' ',lause)));
	delete(lause,1,pos(' ',lause));
	end;

writeln(lause);
readln;
end.