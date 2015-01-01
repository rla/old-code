program punktid2html;

{$APPTYPE CONSOLE}
uses
  SysUtils, Dialogs, DateUtils;
const
  setnimi='remote.ini';
  pfail='punktid.ini';
  outfail='punktid.html';

function getpts(rida:string):longint;
  var
    posit:byte;
    tmp:string;
    tmpint:longint;
    code:integer;
  begin
  posit:=pos('=', rida);
  tmp:=copy(rida, posit+1, length(rida)-posit);
  val(tmp, tmpint, code);
  getpts:=tmpint;
  end;//getpts

function getnimi(rida:string):string;
  var
    posit:byte;
    tmp:string;
  begin
  posit:=pos('=', rida);
  tmp:=copy(rida, 1, posit-1);
  getnimi:=tmp;
  end;//getnimi

var
  fail, ofail, setfile:text;
  ridu:longint;//ridade arv
  i:longint;
  max, min:longint;
  tmppts:longint;
  rida, kanal, server:string;
  count:integer;//mitmes
  kuupaev:TDateTime;
  aeg:TDateTime;
  posit:integer;
label
  lopp;
begin
count:=0;
writeln('by Raivo Laanemets');
writeln('Punktid2html käivitatud.');
if not(FileExists(pfail)) then
  begin
  writeln('Faili ', pfail,' ei leitud.');
  goto lopp;
  end;
writeln('Fail ', pfail, ' leitud.');

if not(FileExists(setnimi)) then
  begin
  writeln('Faili ', setnimi,' ei leitud.');
  goto lopp;
  end;
writeln('Fail ', setnimi, ' leitud.');

assign(setfile, setnimi);
reset(setfile);
while not(eof(setfile)) do
  begin
  readln(setfile, rida);
  if pos('kanal', rida)>0 then
    begin
    posit:=pos('kanal', rida);
    kanal:=copy(rida, posit+6, length(rida)-posit-5);
    end;
  if pos('server', rida)>0 then
    begin
    posit:=pos('server', rida);
    server:=copy(rida, posit+7, length(rida)-posit-6);
    end;
  end;
close(setfile);

assign(fail, pfail);
assign(ofail, outfail);
reset(fail);
rewrite(ofail);

kuupaev:=Date;
aeg:=Time;
writeln(ofail, '<html><head>');
writeln(ofail, '<style type="text/css">');
writeln(ofail, '<!--');
writeln(ofail, '.tabel {');
writeln(ofail, 'font-size:11pt ;');
writeln(ofail, 'background-color:#eeeeee }');
writeln(ofail, '-->');
writeln(ofail, '</style>');
writeln(ofail, '<title>[', kanal, '] trivia punktid</title>');
writeln(ofail, '<body bgcolor="#eeeeee">');
writeln(ofail, '<font face="courier">Server: ',server,'<br>Kanal: ',kanal,'<br>Tabel kostatud:');
writeln(ofail, DayOf(kuupaev), '-', MonthOf(kuupaev), '-', YearOf(kuupaev));
writeln(ofail, HourOf(aeg), ':', MinuteOf(aeg), ':', SecondOf(aeg), '<br><br><br></font>');
writeln(ofail, '<table align="center" bgcolor="#999999" border="0" cellspacing="0" cellpadding="0" width="100%"><tr><td>');
writeln(ofail, '<table width="100%" cellspacing="1">');
writeln(ofail, '<tr><td align="left" bgcolor="#999999"><font color="#ffffff" size="2"><b>Koht</b></font></td>');
writeln(ofail, '<td align="left" bgcolor="#999999"><font color="#ffffff" size="2"><b>Nimi</b></font></td>');
writeln(ofail, '<td align="left" bgcolor="#999999"><font color="#ffffff" size="2"><b>Punktid</b></font></td></tr>');

ridu:=0;
while not(eof(fail)) do
  begin
  readln(fail, rida);
  inc(ridu);
  end;
writeln('Failis on ', ridu,' rida.');

max:=10000000;
for i:=1 to ridu do
  begin
  reset(fail);
  readln(fail, rida);//kaotatakse rida [punktid]
  min:=0;
  while not(eof(fail)) do
    begin
    readln(fail, rida);
    tmppts:=getpts(rida);
    if (tmppts>min) and (tmppts<max) then min:=tmppts;
    end;
  max:=min;

  reset(fail);
  readln(fail, rida);//kaotatakse rida [punktid]
  while not(eof(fail)) do
    begin
    readln(fail, rida);
    tmppts:=getpts(rida);
    if tmppts=min then
      begin
      inc(count);
      writeln(ofail, '<tr><td class="tabel">', count, '.</td>');
      writeln(ofail, '<td class="tabel">', getnimi(rida), '</td>');
      writeln(ofail, '<td class="tabel">', getpts(rida), '</td></tr>');
      end;
    end;
  end;

writeln(ofail, '</table></td></tr></table>');
writeln(ofail, '<br><font face="courier">&copy;Jc Trivia 2003</body>');
close(fail);
close(ofail);

lopp:
writeln('Programm lõpetatud.');
end.
