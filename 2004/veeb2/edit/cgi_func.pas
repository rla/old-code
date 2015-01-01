unit cgi_func;

{
Pascalis CGI kasutamist abistavad funktsioonid.
Raivo Laanemets 2004
}

interface

procedure Include(failinimi: string);

implementation

procedure Include(failinimi: string);
var F: text; ch: char;
begin
  AssignFile(F, failinimi); Reset(F);
  while not(eof(F)) do
  begin
    Read(F, ch); Write(ch);
  end;
  CloseFile(F);
end;

end.
