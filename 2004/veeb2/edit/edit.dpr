program edit;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  pas_cgi in 'pas_cgi.pas',
  cgi_func in 'cgi_func.pas';

type
andmekirje=record
  nimi: string[10]; {muutuja nimi}
  vaartus: string[255]; {muutuja väärtus}
end;

objektityyp=(html, thtml, err, css); {err kasutatakse vea tähistamiseks,
näiteks kui objekti kirjeldust ei asu failis}

{objektide kirjeldused asuvad ühises failis}
objektikirje=record
  nimi: string[10]; {objekti nimi}
  tyyp: objektityyp; {tüübiks võib html või templeit}
end;

var page: string; {POST meetodiga saadetud andmete pikkus}
  cgi: Tcgi; {cgi kasutamine}
  login: boolean; {kasutatakse sisselogimise kontrolliks}
  pass, user: string; {sisseloginud kasutaja andmed}

procedure NaitaObjekte; {objektide nimekirja toomine ekraanile}
var F: file of objektikirje; i: word; obj: objektikirje;
begin
  writeln('<table class="objektid">');
  writeln('<tr><td><b>Objekt</b></td><td><b>Tüüp</b></td></tr>');
  AssignFile(F, 'objektid.dat'); Reset(F);
  for i:=1 to FileSize(F) do
  begin
    Read(F, obj);
    write('<tr><td><a href="?page=obj&amp;obj=' +obj.nimi +'">' +obj.nimi +'</a></td><td>');
    case obj.tyyp of
      html: write('html</td>');
      thtml: write('thtml</td>');
      css: write('css</td>');
    end;
    writeln('</tr>');
  end;
  CloseFile(F);
  writeln('</table>');
end;

{Objekti info näitamine}
procedure ObjektiInfo(nimi: string);
var F: file of objektikirje; i: word; obj: objektikirje; fk: TextFile;
  keel: string[2]; tyyp: string;
begin
  writeln('<div class="objektiinfo">');
  AssignFile(F, 'objektid.dat'); Reset(F);
  for i:=1 to FileSize(F) do
  begin
    Read(F, obj);
    if obj.nimi=nimi then break;
  end;
  CloseFile(F);                            
  writeln('Objekt: <b>' +nimi +'</b><br>');
  write('Tüüp: <b>');
  if obj.tyyp=css then tyyp:='css'
  else if obj.tyyp=html then tyyp:='html'
  else if obj.tyyp=thtml then tyyp:='thtml';
  writeln(tyyp +'</b><br>');

  if obj.tyyp=html then
  begin
    writeln('Kood: ');
    AssignFile(fk, 'keeled.txt'); Reset(fk);
    while not(eof(fk)) do begin
      Readln(fk, keel);
      writeln(' <a href="?page=kood&amp;obj=' +nimi +'&amp;keel=' +keel +'&amp;tyyp=html">' +keel +'</a>');
    end;
    CloseFile(fk);
  end
  else if obj.tyyp=thtml then
  begin
    writeln('<a href="?page=kood&amp;obj=' +nimi +'&amp;tyyp=thtml">Kood</a><br>');
    writeln('Andmed: ');
    AssignFile(fk, 'keeled.txt'); Reset(fk);
    while not(eof(fk)) do begin
      Readln(fk, keel);
      writeln(' <a href="?page=data&amp;obj=' +nimi +'&amp;keel=' +keel +'">' +keel +'</a>');
    end;
    CloseFile(fk);
  end else writeln('<a href="?page=kood&amp;obj=' +nimi +'&amp;tyyp=css">Kood</a><br>');
  writeln('</div>');
end;

{Objekti koodi väljastamine}
procedure ObjektiKood(nimi, tyyp, keel: string);
var fnimi: string; F: TextFile; ch: char;
begin
  if tyyp='html' then fnimi:='./html/' +nimi +'.' +keel +'.html'
  else if tyyp='thtml' then fnimi:='./thtml/' +nimi +'.tpl'
  else fnimi:='./css/' +nimi +'.css'; writeln('Objekti <b>' +nimi +'</b> kood<br>');
  writeln('<form method="post" action="edit"><input type="hidden" name="salvesta" value="1">');
  writeln('<input type="hidden" name="fnimi" value="' +fnimi +'">');
  writeln('<textarea cols="80" rows="20" name="kood">');
  AssignFile(F, fnimi); Reset(F);
  while not(eof(F)) do begin
    Read(F, ch); if ch='<' then write('&#60;') else if ch='>' then write('&#62;') else write(ch);
  end;
  CloseFile(F);
  writeln('</textarea><input type="submit" value="salvesta" class="button"></form>');
end;

{objekti koodi salvestamine kettale}
procedure SalvestaObjekt;
var F: TextFile; fnimi: string;
begin {$I-}
  fnimi:=cgi.Post('fnimi');
  AssignFile(F, fnimi); Rewrite(F);
  if IOResult=0 then begin
    write(F, cgi.Post('kood'));
    writeln('Fail <b>', fnimi, '</b> edukalt salvestatud.');
    CloseFile(F);
  end else writeln('Faili <b>', fnimi, '</b> ei saa salvestada.');
  {$I+}
  writeln('<br><a href="edit">Esilehele</a>');
end;

procedure NaitaDatat;
var F: file of andmekirje; fnimi: string; data: andmekirje; i: word;
begin {$I-}
  fnimi:='./data/' +cgi.Get('obj') +'.' +cgi.Get('keel') +'.dat';
  AssignFile(F, fnimi); Reset(F);
  if IOResult=0 then begin
    writeln('Fail <b>', fnimi, '</b><br><table>');
    for i:=1 to FileSize(F) do begin
      Read(F, data);
      writeln('<tr><td>' +data.nimi +'</td><td>' +data.vaartus +'</td><td><a href="?page=data_muuda&amp;item=' +IntToStr(i) +'&amp;file=' +fnimi +'">Muuda</a></td></tr>');
    end;
    CloseFile(F);
    writeln('</table><br><a href="?page=data_lisa&amp;file=' +fnimi +'">Lisa</a>');
  end else writeln('Faili <b>', fnimi, '</b> ei saa avada.');
  {$I+}
end;

procedure DataLisa; {lisamise vormi toomine ekraanile}
begin
  writeln('<form method="post" action="edit"><input type="hidden" name="file" value="' +cgi.Get('file') +'">');
  writeln('Muutuja nimi:<br><input type="text" name="nimi"><br>');
  writeln('Muutuja vaartus:<br><input type="text" name="vaartus"><br><br>');
  writeln('<input type="hidden" name="page" value="data_lisa_do"><input type="submit" value="Salvesta">');
  writeln('</form>');
end;

procedure DataMuuda;
begin
  writeln('<form method="post" action="edit"><input type="hidden" name="file" value="' +cgi.Get('file') +'">');
  writeln('<input type="hidden" name="item" value="' +cgi.Get('item') +'">');
  writeln('Uus muutuja vaartus:<br><input type="text" name="vaartus"><br><br>');
  writeln('<input type="hidden" name="page" value="data_muuda_do"><input type="submit" value="Salvesta">');
  writeln('</form>');
end;

procedure DataLisa_do; {andmete lisamine}
var F: file of andmekirje; data: andmekirje; fnimi: string;
begin {$I-}
  fnimi:=cgi.Post('file');
  AssignFile(F, fnimi); Reset(F);
  if IOResult=0 then begin
    data.nimi:=cgi.Post('nimi'); data.vaartus:=cgi.Post('vaartus');
    Seek(F, FileSize(F)); Write(F, data);
    CloseFile(F);
    writeln('Faili <b>', fnimi, '</b> lisatud!<br><a href="?page=data_lisa&amp;file=' +fnimi +'">Lisa veel</a>');
  end else writeln('Faili <b>', fnimi, '</b> ei saa avada.');
{$I+}
end;

procedure DataMuuda_do; {andmete muutmine}
var F: file of andmekirje; data: andmekirje; fnimi: string; place: word;
begin {$I-}
  fnimi:=cgi.Post('file');
  AssignFile(F, fnimi); Reset(F);
  if IOResult=0 then begin
    place:=StrToInt(cgi.Post('item'))-1; Seek(F, place); Read(F, data);
    data.vaartus:=cgi.Post('vaartus');
    Seek(F, place); Write(F, data);
    CloseFile(F);
    writeln('Faili <b>', fnimi, '</b> sisu muudetud!');
  end else writeln('Faili <b>', fnimi, '</b> ei saa avada.');
{$I+}
end;

begin

cgi.Create;

{sisselogimise kontroll}
if cgi.Post('login')='1' then begin
  cgi.SendCookie('user=' +cgi.Post('user'), 0);
  cgi.SendCookie('pass=' +cgi.Post('pass'), 0);
  write('Location:./edit' +chr(10));
  cgi.SendHeader;
  cgi.Close; exit;
end;

cgi.SendHeader;
Include('./edit_data/header.html'); {lehekülje päise näitamine}

if cgi.Cookie('user')='' then begin
  Include('./edit_data/login.html');
  login:=false;
end
else if cgi.Cookie('pass')<>'killer' then begin
  Writeln('Vale parool!<br>');
  Include('./edit_data/login.html');
  login:=false;
end else login:=true;

if login then begin
  writeln('Kasutaja: <b>' +cgi.Cookie('user') +'</b><br><br>');
  page:=cgi.Get('page'); if page='' then page:='index';
  if cgi.Post('salvesta')='1' then SalvestaObjekt
  else if cgi.Post('page')='data_lisa_do' then DataLisa_do
  else if cgi.Post('page')='data_muuda_do' then DataMuuda_do
  else if (page='index') then NaitaObjekte
  else if page='obj' then ObjektiInfo(cgi.Get('obj'))
  else if page='kood' then ObjektiKood(cgi.Get('obj'), cgi.Get('tyyp'), cgi.Get('keel'))
  else if page='data' then NaitaDatat
  else if page='data_lisa' then DataLisa
  else if page='data_muuda' then DataMuuda;
end;
Include('./edit_data/footer.html');
cgi.Close;
end.
