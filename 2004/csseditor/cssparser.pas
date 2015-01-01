unit CSSParser;

{
Moodul CssParser.

Css failide lugemine ning nende sisu parsimine
meediumideks, klassideks ja muutujate-väärtuste paarideks.

Alustatud: 10.02.2004
Viimati muudetud: 14.02.2004

(c) Raivo Laanemets 2004
rl@starline.ee

Klass TCss
  Muutujad:
    Count - meediumide arv konteineris.

  Protseduurid:

    Init - tuleb kutsuda enne klassi TCss
      edasist kasutamist. Protseduur LoadFromFile
      teeb seda automaatselt.

    LoadFromFile(FileName: string) - css lugemine failist FileName.
      Parsib faili sisu.

    Add(AMedia, AClass, AField, AValue) - css konteinerisse uue meediumi
      või klassi lisamine, kui meedium pole määratud, st. on üldine, siis
      tuleb AMedia väärtuseks anda 'general';

    GetMediaClasses(index: integer, var List: TCssStrList) - meediumi
      klasside nimekirja saamine.

    GetClassNodes(mindex, cindex: integer; var List: TCssValList) -
      klassi muutujate nimekirja saamine. mindex - meediumi järjekorranumber,
      cindex - klassi järjekorranumber.

  Funktsioonid:
    GetMediaName(index: integer) - meediumi nime saamine tema järjekorranumbri järgi.
}
interface
uses SysUtils, CSSClass, CSSNode, CSSStatement, CSSMedium, CSSList;

type

TCss=object
  Statements: TCssStatements; {Üksikud css laused}
  FirstMedia: TCssMediaPtr;   {Viit esimesele meediumile}
  MediaName: string;          {Viimati kasutatud meediumi nimi}
  Count: integer;             {meediumide arv}

  procedure Init;                                                          {muutujat nullimine}
  procedure LoadFromFile(FileName: string);                                {loeb css andmed failist}
  function GetMediaName(index: integer): string;                           {meediumi nime saamine}
  procedure Add(AMedia, AClass, AField, AValue: string);                   {lisamine}
  procedure GetMediaClasses(index: integer; var List: TCssStrList);        {meediumi klasside saamine}
  procedure GetClassNodes(mindex, cindex: integer; var List: TCssValList); {klassi muutuja-väärtuse paati tagastamine}

  private
  procedure ParseBlock(ABuffer: string); //tükeldab puhvri muutujateks.
  procedure AddStatement(AStatement: string); //üksiku lause lisamine.
  procedure AddMedia(AMedia: string); //meediumi lisamine.
  function Strip(ABuffer: string): string; //eemaldab ebasobivad märgid.
end;{TCss}

implementation

const validchars=['a'..'z', '-', '{', '}', '(', ')', ';', '\', ',', '_', '@', '0'..'9', ' ', ':', '[', ']', '='];

{
TCss funktsioonid ja protseduurid.
Init käivitatakse automaatselt, kui
loetakse css andmed failist. Luuakse
konteiner üksiklausete ja meediumide tarbeks.
}
procedure TCss.Init;
begin
  Count:=0;
  Statements.Create;
  FirstMedia:=nil;
end;

{
LoadFromFile(filename) - css faili
sisu loetakse failist (.css) ning toimub vajalik
parsimine, sisu jaotamine meediumide järgi klassideks ja
need omakorda muutuja-väärtuse paarideks.
Parsimise algusfaasis jaotatkse css fail blokkideks, mille
määravad loogilised sulud.
}
procedure TCss.LoadFromFile;
var
  fm: TextFile;
  ch: char;
  buffer: string;
  block: boolean;
  curl_count: integer;
  class_name: string;
  label ParseError;
begin
  Init; {TCss initsialiseerimine}
  AssignFile(fm, FileName);
  Reset(fm);
  buffer:='';
  block:=false;
  curl_count:=0;
  while not(eof(fm)) do
  begin
    Read(fm, ch);
    {
    Parsimise ajal eemaldatakse realõpud,
    rea algused ning tühjad '' märgid.
    }
    if (ch<>'#10') and (ch<>'#13') and (ch<>'') then buffer:=buffer +ch;
    {
    Üksik rida lõpeb märgiga ; ja ei sisalda loogilisi sulge.
    }
    if (ch=';') and (curl_count=0) and (length(buffer)>2) then
    begin
      AddStatement(buffer);
      buffer:='';
    end;
    if ch='{' then begin inc(curl_count); block:=true; end;
    if ch='}' then dec(curl_count);
    {
    Plokk eraldatakse sel teel, kui iga paremale
    avanev loogiline sulg on leidnud paarilise.
    }
    if block and (curl_count=0) then
    begin
      ParseBlock(Strip(buffer));
      buffer:='';
      block:=false;
    end;
  end;
  exit;
  ParseError:
  //showmessage('Parse error');
  CloseFile(fm);
end;

{
ParseBlock - ühe osa failist parsimine.
Leitud meedium (kui üldse) ning klassid
ja nende muutujad lisatakse mällu.
}
procedure TCss.ParseBlock;
var
  i :integer;
  ch:char;
  media: string;
  start: integer;
  cl_name: string;
  lbuffer: string;
  var_name: string;
begin
  start:=1;
  media:='general';
  {
  Kui tegemist on meediumi klassiga,
  siis ereldatakse meediumi nimi ja jätkatakse
  edasist parsimist meediumi klassi sees.
  }
  if pos('@media', ABuffer)>0 then
  begin
    media:=copy(ABuffer, 8, pos('{', ABuffer)-8);
    start:=pos('{', ABuffer)+1; //koht, kust jätkatakse edasist parsimist
  end;

  for i:=start to length(ABuffer) do
  begin
    ch:=ABuffer[i];
    {
    Klass algab paremale avaneva loog. suluga.
    }
    if ch='{' then
    begin
      cl_name:=lbuffer;
      lbuffer:='';
    end;
    {
    Muutujat ja väärtust eraldab koolon.
    }
    if ch=':' then
    begin
      var_name:=lbuffer;
      lbuffer:='';
    end;
    {
    Muutuja-väärtuse paar võib lõppeda semikooloniga
    või sulgeva loog. suluga (klassi lõpp).
    }
    if ((ch=';') or (ch='}')) and (length(lbuffer)>0) then //muutuja väärtus on käes.
    begin
      Add(trim(media), trim(cl_name), trim(var_name), trim(lbuffer));
      lbuffer:='';
    end;
    if (ch<>'{') and (ch<>'}') and (ch<>';') and (ch<>':') then lbuffer:=lbuffer +ch;
  end;
end;

{
Css konteinerisse lisamisel otsitakse
lisatava meediumi nime, kui seda ei ole, siis
tekitatakse uus meediumi ja klass lisatakse sinna.
}
procedure TCss.Add;
var
  current: TCssMediaPtr;
  found: boolean;
begin
    current:=FirstMedia;
    found:=false;

    while (current<>nil) do {Otsitakse antud nimega meediumit}
    begin
      if current^.Name=LowerCase(AMedia) then
      begin
        current^.Add(AClass, AField, AValue);
        found:=true;
      end;
      current:=current^.Next;
    end;

    if not(found) then
    begin
      AddMedia(LowerCase(AMedia));
      FirstMedia^.Add(AClass, AField, AValue);
    end;
end;

{
Css meediumist/klassist/muutujast/väärtusest
eemaldatakse mittesobivad tähemärgid
ning kommentaarid.
}
function TCss.Strip;
var
  lbuffer: string;
  i: integer;
  comment: boolean;
  ch: char;
begin
  lbuffer:='';
  comment:=false;
  for i:=1 to length(ABuffer) do
  begin
    ch:=ABuffer[i];
    if (ch='*') and (i>1) and (ABuffer[i-1]='/') then comment:=true;//kommentaari algus
    if (ch='/') and (i>1) and (ABuffer[i-1]='*') then comment:=false;
    if (LowerCase(ch)[1] in validchars) and not(comment) then lbuffer:=lbuffer +ch;
  end;
  Strip:=lbuffer;
end;

{
Css konteinerisse üksiklause lisamine.
}
procedure TCss.AddStatement;
begin
  Statements.Add(AStatement);
end;

{
Uue meediumi lisamine.
}
procedure TCss.AddMedia;
var new_media: TCssMediaPtr;
begin
  inc(Count);
  New(new_media);
  new_media^.Create;
  new_media^.Name:=AMedia;
  new_media^.Next:=FirstMedia;
  MediaName:=AMedia;
  FirstMedia:=new_media;
end;

{
Funktsioon meediumi nime saamiseks
tema järjekorranumbri kaudu css konteinerist.
}
function TCss.GetMediaName;
var
  current: TCssMediaPtr;
  i: integer;
begin
  GetMediaName:='';
  if index<0 then exit;
  if index>Count then exit;
    current:=FirstMedia;
    i:=0;
    while (current<>nil) and (i<=index) do
    begin
      GetMediaName:=current^.Name;
      current:=current^.Next;
      inc(i);
    end;
end;

{
Protseduur meediumi klasside saamiseks
meediumi järjekorranumbri järgi. Klasside nimekiri
pannakse parameetrilisse muutujasse List (tüüp TCssStrList).
}
procedure TCss.GetMediaClasses;
var
  current: TCssMediaPtr;
  cur_class: TCssClassPtr;
  i: integer;
begin
  List.Create;
  if index<0 then exit;
  if index>Count then exit;
  current:=FirstMedia;
  i:=0;
  while (current^.Next<>nil) and (i<index) do {Meediumi leidmine}
  begin
    current:=current^.Next;
    inc(i);
  end;
  cur_class:=current^.FirstClass;
  while cur_class<>nil do
  begin
    List.Add(cur_class^.Name);
    cur_class:=cur_class^.Next;
  end;
end;

{
Klassi muutujate-väärtuste nimekirja
saamine meediumi ja klassi järjekorranumbri järgi.
Muutuja-väärtuse paar pannakse nimekirja,
mille moodustab parameetriline muutuja List (tüüp TCssValList);
}
procedure TCss.GetClassNodes;
var
  current: TCssMediaPtr;
  cur_class: TCssClassPtr;
  cur_node: TCssNode;
  i: integer;
begin
  List.Create;
  if mindex<0 then exit;
  if mindex>Count then exit;
  current:=FirstMedia;

  i:=mindex;
  while (current^.Next<>nil) and (i>0) do {meediumi leidmine}
  begin
    current:=current^.Next;
    dec(i);
  end;

  cur_class:=current^.FirstClass;
  i:=current^.Count-cindex-1;
  while (cur_class^.Next<>nil) and (i>0) do {klassi leidmine}
  begin
    cur_class:=cur_class^.Next;
    dec(i)
  end;

  cur_node:=cur_class^.First; {nimekirja lisamine}
  while cur_node<>nil do
  begin
    List.AddNode(cur_node^);
    cur_node:=cur_node^.Next;
  end;
end;

end.
