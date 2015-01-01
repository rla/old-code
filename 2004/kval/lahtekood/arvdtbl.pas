unit arvdtbl;
{
Kvalifikatsioonieksam 2004
Arvude sailitamiseks moeldud tabeli kasutamise funktsioonid.
Funktsioonide nimed algavad eesliitega -at.

Raivo Laanemets


korrutamine: atKorruta(t1, t2, tulem: char);
t1 ja t2 on korruatavad arvud ning tulem on
arvude indekstabelis arvu nimi, kuhu salvestatakse tulemus.
}

interface
uses sredarvd;

type
  TArv=record
    nimi: char;
    pikkus: byte;
    index: word;
  end;

var
  arvude_index: array [1..4096] of TArv; {arvude indeksite tabel}
  arvud: array [1..40960] of byte; {arvude tabel}
  arvude_index_i: word; {näitab, mitmes on viimane lisatud arv}

procedure atPuhasta; {arvude indeksite ja tabeli puhastamine}
procedure atValjasta(nimi: char); {arvu väljastamine tema nime järgi}
procedure atRandom(nimi: char); {juhusliku arvu nimega nimi loomine tabelisse}
procedure atLisa(sis: TSuurArv; nimi: char); {arvu nimega nini lisamine tabelisse}
procedure atIndexTabel(algus, ridade_arv: word); {arvude indeksi tabeli väljastamine}
procedure atArvudTabel(algus, arv: word); {arvude tabeli väljastamine}
procedure atVaataByIndex(var sis: TSuurArv; index: word); {tabelist kohalt index arvu võtmine}
procedure atVaataByNimi(var sis: TSuurArv; nimi: char); {tabelist arvu võtmine arvu nime järgi}
procedure atKorruta(t1, t2, tulem: char); {vt. järgmise kirjeldust}
function atKorrutaByIndex(indexof1, indexof2: word; nimi: char): word; {kahe arvu
korrutamine, kui on antud arvude indeksid indekstabelis, annab tulemi
indeksi, arvu nime ei muudeta (jääb #0)}

function atIndexByNimi(nimi: char): word; {arvu indeksi leidmine tema nime järgi,
kui antud nimega arv puudub tabelist, siis on saadav väärtus 0}
function atLeiaVabaIndex(arvu_pikkus: byte): word; {kohaliku tähtsusega}

implementation

{suvalise arvu genereerimine tabelisse}
procedure atRandom(nimi: char);
var tmp: TSuurArv;
begin
  saTyhjendaArv(tmp);
  saRndArv(tmp, Random(260));
  atLisa(tmp, nimi);
end;

{arvu väljastamine}
procedure atValjasta(nimi: char);
var
  arv: TSuurArv;
  i: word;
begin
  atVaataByNimi(arv, nimi);

  if arv[255]>=240 then write('-');
  for i:=saLenOf10Arv(arv)-1 downto 0 do write(saGet10Arv(arv, i));
end;


{arvu indeksi leidmine tema nime järgi}
function atIndexByNimi(nimi: char): word;
var i: word;
begin
  atIndexByNimi:=0;
  for i:=1 to arvude_index_i do
  begin
    if arvude_index[i].nimi=nimi then atIndexByNimi:=i;
  end;
end;

{arvude korrutamine nende nimede järgi}
procedure atKorruta(t1, t2, tulem: char);
begin
  {saaks lisakiirust, kui arvude indeksid leida korraga}
  atKorrutaByIndex(atIndexByNimi(t1), atIndexByNimi(t2), tulem);
end;

{arvu vaatamine nime järgi}
procedure atVaataByNimi(var sis: TSuurArv; nimi: char);
var i: word;
begin
  {indeksi leidmine}
  i:=atIndexByNimi(nimi);
  if i<>0 then atVaataByIndex(sis, i);
end;

{arvude korrutamine nende indeksite alusel}
function atKorrutaByIndex(indexof1, indexof2: word; nimi: char): word;
var t1, t2, tulem: TSuurArv;
begin
  {arvude saamine tabelist}
  saTyhjendaArv(tulem);
  saTyhjendaArv(t1); saTyhjendaArv(t2);
  atVaataByIndex(t1, indexof1);
  atVaataByIndex(t2, indexof2);
  saKorruta(t1, t2, tulem);
  atLisa(tulem, nimi);
  atKorrutaByIndex:=arvude_index_i; {viimati lisatud Tarvu index}
end;

{tabelist arvu võtmine etteantud indeksi järgi}
procedure atVaataByIndex(var sis: TSuurArv; index: word);
var
  arv: TArv;
  i: word;
  tmp: TSuurArv;
begin
  saTyhjendaArv(tmp);
  saTyhjendaArv(sis);
  arv:=arvude_index[index];
  {arvu võtmine massiivist}
  for i:=arv.index to arv.index +arv.pikkus-1 do
  begin
    tmp[i-arv.index]:=arvud[i];
  end;
  {arvu viimine kujule TSuurArv}
  saUCompress(tmp, sis);
end;

{arvude tabeli toomine ekraanile, vajalik silumiseks}
procedure atArvudTabel(algus, arv: word);
var i: integer;
begin
  writeln('-----');
  writeln('Arvud');
  writeln('-----');
  for i:=algus to arv+algus do
  begin
    write(arvud[i], '.');
  end;
  writeln;
  writeln('-----');
end;

{arvude indeksi tabeli toomine ekraanile, vajalik silumiseks}
procedure atIndexTabel(algus, ridade_arv: word);
var i: integer;
begin
  writeln('-----');
  writeln('Arvude indeksid');
  writeln('-----');
  for i:=algus to algus+ridade_arv-1 do
  begin
    write('nimi':7); write('pikkus':7); writeln('index':7);
    write(arvude_index[i].nimi: 7);
    write(arvude_index[i].pikkus: 7);
    writeln(arvude_index[i].index: 7);
  end;
  writeln('-----');
end;

{antu pikkusega arvu jaoks vaba ja sobiva koha leidmine}
function atLeiaVabaIndex(arvu_pikkus: byte): word;
var
  i: word;
  index: word;
  pk: word;
begin
  if arvude_index_i=0 then
  begin
    atLeiaVabaIndex:=1;
    exit;
  end else
  begin
    for i:=1 to arvude_index_i do
    begin
      {kontrollime kas antud arvu saab vahele lükata,
      pole implementeeritud}
      {pk:=arvude_index[i].pikkus;
      if (pk=0) or (pk>=arvu_pikkus) then }
      index:=arvude_index[i].index+arvude_index[i].pikkus;
    end;
  end;
  atLeiaVabaIndex:=index;
end;

procedure atLisa(sis: TSuurArv; nimi: char);
var
  pk: word;
  uusarv: TArv;
  i: word;
begin
  uusarv.nimi:=nimi;

  saCompress(sis, sis);

  uusarv.pikkus:=saCompress(sis, sis); {!!!!}

  {indeksi leidmine}
  uusarv.index:=atLeiaVabaIndex(uusarv.pikkus);
  inc(arvude_index_i);

  {lisamine arvude massiivi}

  for i:=uusarv.index to uusarv.index +uusarv.pikkus do arvud[i]:=sis[i-uusarv.index];

  {lisamine arvude indeksite massi}
  arvude_index[arvude_index_i]:=uusarv;
end;

procedure atPuhasta;
var
  i: word;
  arv:TArv;
begin
  arv.nimi:=#0; {vaikimisi (tühi) arvu nimi}
  arv.pikkus:=0;
  arv.index:=0;
  for i:=1 to 4096 do arvude_index[i]:=arv;
  for i:=1 to 40960 do arvud[i]:=0;
  arvude_index_i:=0;
end;

end.