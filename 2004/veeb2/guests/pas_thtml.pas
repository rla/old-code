unit pas_thtml;

{
Templeiditud html'i kasutamise funktsioonid.
Raivo Laanemets 2004
rl@starline.ee
}

interface

type
Tobjtyyp=(t_html, t_thtml, t_text, t_css, t_err); {objekti tüüp}
Tobjektikirje=record {html objekti kirjeldav kirje}
  nimi: string[15]; {objekti nimi}
  tyyp: Tobjtyyp;
  data: string[10]; {andmefaili nimi}
end;

Tthtml=object
  public
  procedure TempList(var fstring: string);

  private
end;

implementation

procedure Tthtml.TempList(var fstring: string);
begin
end;

end.
