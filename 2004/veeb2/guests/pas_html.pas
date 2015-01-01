unit pas_html;

{
moodul pas_html on mõeldud cgi rakenduste loomise lihtsustamiseks.
Raivo Laanemets 2004
rl@starline.ee
}

interface

uses pas_cgi;

type
Thtml=object
  public
  cgi: Tcgi; {cgi abistav süsteem}
  page: string; {sisu näitav muutuja}
  procedure Create; {algmuutujate sätted}
  procedure Close; {mälu vabastamine}
  procedure Include(failinimi: string); {väljastab faili}
  procedure LineBr(inp: string); {väljastab rea, mille lõppu lisatakse <br>}
  function TagEnc(inp: string): string; {html täägi tähiste < ja > kodeerimine}
end;

implementation

procedure Thtml.Close;
begin
  cgi.Close;
end;

procedure THtml.Create;
begin
  cgi.Create; {cgi kasutamise algus}
  page:=cgi.Get('page'); if page='' then page:=cgi.Post('page');
  if page='' then page:='index';
end;

procedure Thtml.LineBr(inp: string);
begin
  writeln(inp +'<br>');
end;

procedure Thtml.Include(failinimi: string);
var F: text; ch: char;
begin
  AssignFile(F, failinimi); Reset(F);
  while not(eof(F)) do begin
    Read(F, ch); Write(ch);
  end;
  CloseFile(F);
end;

function THtml.TagEnc(inp: string): string;
var i: word; ch: char; outp: string;
begin
  outp:='';
  for i:=1 to length(inp) do begin
    ch:=inp[i]; if ch='<' then outp:=outp +'&#60;' else
    if ch='>' then outp:=outp +'&#62;' else outp:=outp +ch;
  end;
  TagEnc:=outp;
end;

end.
