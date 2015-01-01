unit sredarvd;
{
Kvalifikatsioonieksam 2004
Arvudega tehete tegemise funktsioonid.
Funktsioonide nimed algavad eesliitega -sa.

Raivo Laanemets

}
interface

type
  TSuurArv=array [0..255] of byte;
  {iga kumnendnumber votab 4 bitti,
  255. baidi teine nelik maarab m
rgi:
  1111- negatiivne arv, mingi teine värtus- positiivne}

procedure saSet10Arv(var sis: TSuurArv; osa: word; num: byte); {kumnendarvu
uhe koha seadmine}

procedure saNegArv(var sis: TSuurArv); {arvu muutmine negatiivseks}
procedure saPosArv(var sis: TSuurArv); {arvu muutmine positiivseks}
procedure saKorruta(sis1, sis2: TSuurArv; var tulem: TSuurArv); {arvude korrutamine}
procedure saTyhjendaArv(var sis: TSuurArv); {arvu t
itmine nullidega}

{arvu m
rgi liigutamine suurima numbri ette}
function saCompress(sis: TSuurArv; var val: TSuurArv): byte;

{arvu märgi liigutamine kõrgeimale baidile}
procedure saUCompress(sis: TSuurArv; var val: TSuurArv);

function saGet10Arv(sis: TSuurArv; osa: word): byte; {kumnendarvust
uhe osa saamine
}

function saIsPosArv(sis: TSuurArv): boolean; {arvu märgi kontrollimine}
function saVordle10(sis1, sis2: TSuurArv): boolean; {kümnendarvude võrdlus
kui sis1 on suurem kui sis2, siis funktsioon saab väärtuseks true}

procedure saValjasta10Arv(sis: TSuurArv; baidid: byte); {arvu väljastamine,
väljastatava osa pikkuse määrab baidid (1bait=2kümnendnumbrit)}

procedure saRndArv(var sis: TSuurArv; len: word); {suvalise arvu genereerimine}

function saLenOf10Arv(sis: TSuurArv): word; {kümnendarvu pikkuse saamine}
function saBytesOfArv(sis: TSuurArv): byte; {kümnendarvu moodustavate baitide
hulk, märki määravat baiti ei arvestata}

implementation
uses arvdtbl;


procedure saUCompress(sis: TSuurArv; var val: TSuurArv);
{negatiivse arvu märk viiakse pärast tabelist
võtmist kõrgeima baidi teisele osale (vt. arvdtbl)}
var
  len: byte;
  tmpnum: byte;
begin
  len:=saBytesOfArv(sis);
  if len>0 then tmpnum:=sis[len-1] else tmpnum:=0;
  val:=sis;
  if tmpnum>240 then {viimane number (baidis) arvus näitab märki}
  begin
    if saGet10Arv(sis, (len-1)*2+1)>9 then
    begin
      saNegArv(val);
      saSet10Arv(val, len*2-1, 0);
    end;
  end else if (tmpnum and 15)=15 then {eelviimane number (baidis) näitab märki}
  begin
    val[len-1]:=0;
    saNegArv(val)
  end;
end;

function saCompress(sis: TSuurArv; var val: TSuurArv): byte;
{negatiivse arvu märk viiakse kõige suurema numbri järele enne
arvude massiivi lisamist (vt. arvdtbl)}
var
  lastnum: byte;
  len: byte;
begin
  val:=sis;
  if saIsPosArv(sis) then
  begin
    saCompress:=saBytesOfArv(sis);
  end else
  begin
    len:=saBytesOfArv(sis);
    if len>0 then lastnum:=sis[len-1] else lastnum:=0;
    val[255]:=0; {märgi baidi nullimine}
    {writeln('Lastnum :', lastnum);}
    if lastnum>9 then {viimane arv koosneb kahest osast}
    begin

      val[len]:=15; {00001111, kõrgeim bait arvus}
      saCompress:=len+1;
    end else {viimane arv koosneb ühest osast}
    begin
      saSet10Arv(val, (len)*2-1, 15);
      saCompress:=len;
    end;
  end;
end;

procedure saRndArv(var sis: TSuurArv; len: word);
var i:integer;
begin
  for i:=0 to len-1 do
  begin
    saSet10Arv(sis, i, Random(9));
  end;
end;

procedure saValjasta10Arv(sis: TSuurArv; baidid: byte);
var
  i: byte;
  tmp: byte;
  mask: byte;
begin
  if not(saIsPosArv(sis)) then write('-');
  for i:=baidid downto 0 do
  begin
    tmp:=sis[i];
    write(tmp shr 4);
    mask:=15;
    write(tmp and mask);
  end;
end;

procedure saTyhjendaArv(var sis: TSuurArv);
var i: byte;
begin
  for i:=0 to 255 do sis[i]:=0;
end;

procedure saKorruta(sis1, sis2: TSuurArv; var tulem: TSuurArv);
var
  i, j: word;
  l1, l2: word;
  neg: boolean; {true- tulemus on negatiivne}
  arBuf1, arBuf2: byte;
  accBuf: byte; {arBuf1 ja arBuf2 korrutamisel saadav arv}
  oldBuf: byte; {nihutamisel vana arvu kontrollimine}
  yt: byte;
begin
  if saIsPosArv(sis1)=saIsPosArv(sis2) then neg:=false else neg:=true;
  l1:=saLenOf10Arv(sis1); {pikkused hiljem TArv.pikkus järgi}
  l2:=saLenOf10Arv(sis2);
  {writeln('esimese arvu pikkus:', l1, ' teise arvu pikkus:', l2);}
  yt:=0;
  saTyhjendaArv(tulem);
  {korrutamisel tekkiva võimaliku ületäitumise kontrollimine}
  if l1+l2>511 then exit
  else
    if (sis1[l1-1]+sis2[l2-1]>9) and (l1+l2=510) then
    begin
      {ületäitumise tähistamiseks seame terve baidi väärtuseks 255}
      tulem[0]:=255;
      exit;
    end;

  for i:=0 to l1-1 do
  begin
    arBuf1:=saGet10Arv(sis1, i); {teise arvu numbrid korrutatakse selle numbriga}
    for j:=0 to l2 do {maksimaalne ületäitumine, üks koht pärast arvu lõppu}
    begin
      arBuf2:=saGet10Arv(sis2, j);
      accBuf:=arBuf1*arBuf2; {tehe}

      {tehte tegemine liitmise abil
      ja pidevalt ületäitumise kontrollimine-->}

      accBuf:=accBuf+yt; {liidame eelmises tulemuses olnud ületäituja}
      oldBuf:=saGet10Arv(tulem, j+i);
      accBuf:=oldBuf+accBuf; {liidame vana tulemuse}
      {kontrollime, kas toimus ületäitumine}
      saSet10Arv(tulem, j+i, accBuf mod 10); {korrutades nihkuvad liidetavad arvud ühe võrra vasakule}
      yt:=accBuf div 10; {ületäitumise näitaja saab uue väärtuse}
    end;
  end;
  if neg then saNegArv(tulem);
end;

function saBytesOfArv(sis: TSuurArv): byte;
var
  i:integer;
  ok: boolean;
begin
  ok:=false;
  if saGet10Arv(sis, 510)<>0 then
  begin
    {suurim bait sisaldab peale märgi
    ka numbrit}
    saBytesOfArv:=255;
    exit;
  end;
  i:=255;
  repeat
    dec(i);
    if sis[i]<>0 then ok:=true;
  until ok or (i=0);
  if not(ok) then saBytesOfArv:=0 else
  saBytesOfArv:=i+1; {pikkus indeksist 1 võrra suurem}
end;

function saLenOf10Arv(sis: TSuurArv): word;
var
  i: word;
  ok: boolean;
begin
  ok:=false;
  i:=511;
  repeat
    dec(i);
    if saGet10Arv(sis, i)<>0 then ok:=true;
  until (i=0) or ok;
  i:=i+1;
  saLenOf10Arv:=i;
end;

function saVordle10(sis1, sis2: TSuurArv): boolean;
var
  i: word;
  ok: boolean;
  num1, num2: byte;
begin
  saVordle10:=false;
  {1. märgi võrdlus}
  if saIsPosArv(sis1) and not(saIsPosArv(sis2)) then
  begin
    saVordle10:=true;
    exit;
  end;
  {2. pikkuse võrdlus}
  if saLenOf10Arv(sis1)>saLenOf10Arv(sis2) then
  begin
    saVordle10:=true;
    exit;
  end else if saLenOf10Arv(sis1)<saLenOf10Arv(sis2) then
  begin
      saVordle10:=false;
      exit;
  end;
  {3. numbrite võrdlus}
  i:=saLenOf10Arv(sis1);
  ok:=false;
  repeat
    dec(i);
    num1:=saGet10Arv(sis1, i);
    num2:=saGet10Arv(sis2, i);
    if num1>num2 then
    begin
      saVordle10:=true;
      exit;
    end;
    if num1<num2 then exit;
  until (i=0) or ok;
end;

procedure saPosArv(var sis: TSuurArv);
begin
  saSet10Arv(sis, 511, 0);
end;

procedure saNegArv(var sis: TSuurArv);
begin
  saSet10Arv(sis, 511, 15);
end;

function saIsPosArv(sis: TSuurArv): boolean;
begin
  if saGet10Arv(sis, 511)=15 then saIsPosArv:=false
    else saIsPosArv:=true;
end;

function saGet10Arv(sis: TSuurArv; osa: word): byte;
var
  nb: byte;
  tmp: byte;
  mask: byte;
begin
  nb:=osa div 2;
  tmp:=sis[nb];
  if (osa mod 2)=0 then {arvuks esimene osa baidist}
  begin
    mask:=15;
    tmp:=tmp and mask;
    saGet10Arv:=tmp;
  end else
  begin
    {tmp:=tmp and mask;}
    tmp:=tmp shr 4;
    saGet10Arv:=tmp;
  end;
end;

procedure saSet10Arv(var sis: TSuurArv; osa: word; num: byte);
var
  nb: byte;
  tmp: byte;
  uus: byte;
  mask: byte;
begin
  if osa=65535 then begin writeln('VIGA !! Ületäitumine saSet10Arv()'); exit; end;
  nb:=osa div 2; {baidi asukoht sisendis}
  tmp:=sis[nb];

  if (osa mod 2)<>0 then
  begin
    mask:=15; {saada esimene osa baidist
    seatakse teine osa, 00001111
    arv nihutatakse 4 bitti vaskule}
    num:=num shl 4;
  end
  else mask:=240; {teine osa, 11110000}

  tmp:=tmp and mask; {nullitakse seatavad bitid}
  uus:=num +tmp;
  sis[nb]:=uus;
end;

end.