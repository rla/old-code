program ussimang;{ussimäng}
uses
  crt, graph, dos;

const
  k_korgus=5;                       {kujundi(ruut) kõrgus}
  k_laius=5;                        {---"--- laius}
  aste=5;                           {arv pixlites, näitab kui palju ühe korraga edasi liigutakse}
  mang_labi_text='Mäng Läbi!';      {teade, mida näidatakse kui mäng kaotatud}
  max_pikkus=250;                   {ussi maksimaalne pikkus}
  punktide_fail='punktid.dat';      {punktide faili nimi}
  max_punktide_tabel=23;            {nimede arv punktide tabelis(23 mahub ekraanile)}

type
  koordinaadid=record
    x:integer;
    y:integer;
    nurk:boolean;{näitab kas on tegemist nurgaga}
  end;{koordinaadid}

  type_suund=(y, a, p, v);

  type_punktid=record {punktide faili kirje}
    punktid:integer;
    nimi:string[100];
    sammud:longint;
    aeg_k:real;
    kuupaev:DateTime;
  end;{type punktid}

  type_punktide_tabel=array[1..max_punktide_tabel] of type_punktid;

  type_menuu_item_nimi=string[20];

  type_ei_jah=(ei, jah);

  type_mangu_settingud=record {mängu settingud}
    kujundi_kylg:byte;        {kujundi(ruudu) küljepikkus}
    sounds_on:boolean;        {häälesüsteem}
    pl1_turbo_key:char;       {esimese mängija turbo klahv}
    pl1_pause_key:char;       {teise mängija pausi klahv}
  end;{type_mangu_settingud}

  obj_uss=object
    g_over:boolean;   {true-mäng läbi, false-mäng kestab}
    asi_steps:integer;{sammude arv asja ilmumiseks}
    cur_steps:integer;{sammude arv, nullitakse kui asi käes}
    punktid:integer;  {punktide arv}
    sammud:longint;   {tehtud sammude hulk}
    nimi:string;      {mängija nimi}

    sounds_on:boolean; {mängu häälesüsteem}
    sound_on:boolean;  {näitab, kas hetkel tehakse mingit häält}

    key:char;
    y_key:char;     {klahv -üles}
    a_key:char;     {      -alla}
    p_key:char;     {      -paremale}
    v_key:char;     {      -vasakule}
    turbo_key:char; {      -turbo}
    pause_key:char; {      -paus}

    cur_pikkus:integer;  {ussi pikkus}
    num_nurgad:integer;  {nurkade arv}
    aeg:integer;         {ussi ühe sammu tegemise aeg ms}
    aeg_k:real;
    suund:type_suund;    {ussi liikumise suund}
    tmp_suund:type_suund;{viimane liikumise suund}
    turbo_on:boolean;    {true-uss liigub turbo kiirusega}
    pause_on:boolean;    {true-uss peatatud}

    akna_k:integer; {akna kõrgus}
    akna_l:integer; {akna laius}
    akna_x:integer; {akna x-koht}
    akna_y:integer; {akna y_koht}

    asi:koordinaadid;
    asi_olemas:boolean;

    uss:array [1..max_pikkus] of koordinaadid;

    procedure start;                                    {sätib paika akna mõõtmed jms}

    function check_game:boolean;                          {kontrollib kas mäng kaotatud}
    function check_key:boolean;                           {kontrolib kas kasutaja on vajutanud klahvile}
    function check_asi:boolean;                           {kontrollib, kas asi on kohal}
    function check_asi_ok:boolean;

    procedure pause(onoff:boolean);                       {ussi paus}
    procedure loe_nimi;                                   {loeb sisse mängija nime punktitabeli jaoks}
    procedure arvuta_aeg;                                 {muudab mängu ajal ussi kiirust suuremaks}
    procedure mang_labi_teade;                            {teade, kui mäng kaotatud}
    procedure k_kujund(coord:koordinaadid);               {kujundi kustutamine}
    procedure move_uss;                                   {liigutab ussi ühe sammu võrra}
    procedure set_suund;                                  {ussi suuna paikapanek}
    procedure j_asi;                                      {joonistab midagi ekraanile}
    procedure j_aken;                                     {akna joonistamine}
    procedure m_kujund(alg_koht, lopp_koht:koordinaadid); {kujundi liigutamine}
  end;{obj_uss}

  obj_menuu=object {menüü objekt mitmete menüüde tegemiseks}
    pos_x, pos_y:integer;                          {menüü asukoht ekraanil}
    sel_color:byte;                                {menüü valitud asja värv}
    txt_color:byte;                                {menüü värv}

    valik:byte;                                    {mitmes asi menüüs?}
    valikud:array [1..25] of type_menuu_item_nimi; {valikute nimed, index algab 1-st}
    num_valikud:byte;                              {valikute arv}

    y_key:char;                                    {klahv menüüs üles liikumiseks}
    a_key:char;                                    {klahv menüüs alla liikumiseks}

    procedure start;                       {menüü algseadete paikapanek}
    procedure joonista(x, y:integer);      {menüü toomine ekraanile, kohas x, y}
    procedure yles;                        {minnakse üks valik ülespoole või lõppu}
    procedure alla;                        {minnakse samm alla või algusesse}
    procedure tee_valik;                   {protseduur valiku saamiseks}
    procedure lisa_valik(nimi:type_menuu_item_nimi); {valiku lisamise protseduur}
  end;{obj_menuu}

var
  grd, grm:integer;{graafika}

  uss:obj_uss;{uss-objekt}
  pkirje:type_punktid;
  punktide_tabel:type_punktide_tabel;
  pfile:file of type_punktide_tabel;           {punktide tabeli fail}
  max_punktid:integer;                         {maksimaalne punktide arv}
  min_punktid:integer;                         {minimaalne punktide arv}
  min_koht:integer;                            {minimaalsete punktide asukoht tabelis}
  num_punktid:integer;                         {nimede arv punktide failis}
  p_i:integer;
  p_i_str:string;
  ch:char;
  algmenuu:obj_menuu;     {algusmenüü}
  mangi_veel:type_ei_jah; {}
  mangutyyp:byte;         {mängu tüüp, 1-üksinda, 2-kahekesi jne}

procedure obj_menuu.tee_valik;
var
  pr_ch:char;
begin
  repeat
  pr_ch:=readkey;
  case pr_ch of
    'i':yles;
    'm':alla;
  end;{case pr_ch}
  until pr_ch=#13;
end;

procedure obj_menuu.yles; {menüüs üks valik üles}
var
  valik_str:string;
begin
  SetColor(txt_color);                                  {valge värv}
  OutTextXY(pos_x, pos_y+valik*15, valikud[valik]);
  dec(valik);                                    {vähendame valikut}
  if valik<1 then valik:=num_valikud;
  SetColor(sel_color);
  OutTextXY(pos_x, pos_y+valik*15, valikud[valik]);
end;

procedure obj_menuu.alla; {menüüs üks valik alla}
begin
  SetColor(txt_color);
  OutTextXY(pos_x, pos_y+valik*15, valikud[valik]);
  inc(valik);
  if valik>num_valikud then valik:=1;
  SetColor(sel_color);
  OutTextXY(pos_x, pos_y+valik*15, valikud[valik]);
end;

procedure obj_menuu.lisa_valik(nimi:type_menuu_item_nimi); {menüüsse uue valiku lisamine}
begin
  inc(num_valikud);           {suurendame valikute arvu 1-võrra}
  valikud[num_valikud]:=nimi; {lisame valiku}
end;

procedure obj_menuu.start; {menüü algsätted}
begin
  num_valikud:=0; {valikute arv alguses 0}
  valik:=1;       {algne valik 1}
  y_key:='i';     {üles liikumise klahv}
  a_key:='m';     {alla liikumise klahv}
  sel_color:=6;   {valitud asja värv}
  txt_color:=15;  {menüü värv}
end;

procedure obj_menuu.joonista(x, y:integer); {menüü oomine ekraanile}
var
  pr_i:integer; {protseduuri i}
begin
  pos_x:=x;
  pos_y:=y;
  SetColor(sel_color);
  OutTextXY(x, y+15, valikud[1]);
  SetColor(txt_color);
  for pr_i:=2 to num_valikud do OutTextXY(x, y+pr_i*15, valikud[pr_i]); {kirjutatakse välja menüü valikute nimed}
end;

procedure puhasta_ekraan; {puhastab kõik ekraanil oleva}
begin
  SetFillStyle(1, 0);
  Bar(0, 0, 640, 480);
end;

function ei_jah_dialoog(x, y, l, k:integer; txt: string):type_ei_jah;
var
  pr_ch:char;
begin
  puhasta_ekraan;
  Rectangle(x, y, x+l, y+k);
  Line(x, y+20, x+l, y+20);
  OutTextXY(x+10, y+10, txt);
  OutTextXY(x+40, y+60, 'EI(e)');
  OutTextXY(x+120, y+60, 'JAH(j)');
  pr_ch:='x';
  while (pr_ch<>'j') and (pr_ch<>'e') do pr_ch:=readkey;
  if pr_ch='j' then ei_jah_dialoog:=jah
    else ei_jah_dialoog:=ei;
end;

procedure j_tavaline_aken(scr_x, scr_y, scr_l, scr_k:integer; nimi:string); {algus ekraan, nimega nimi}
begin
  SetColor(15);
  Rectangle(scr_x, scr_y, scr_l+scr_x, scr_k+scr_y);
  Line(scr_x, scr_y-2, scr_l+scr_x, scr_y-2);
  OutTextXY(scr_x+10, scr_y-12, nimi);
end;

procedure jarjesta_tabel;        {tabeli järjestamine}
var
  cur_p:type_punktid;                 {punktid, mida töödeldakse}
  pr_i:integer;
  pr_j:integer;
  tmp_j:integer;
begin
  for pr_i:=1 to max_punktide_tabel-1 do
  begin
    cur_p:=punktide_tabel[pr_i];
    tmp_j:=pr_i;

    for pr_j:=pr_i+1 to max_punktide_tabel do {leitakse järelejäänutest maksimaalne}
    begin
      if punktide_tabel[pr_j].punktid>cur_p.punktid then
      begin
        cur_p:=punktide_tabel[pr_j];
        tmp_j:=pr_j;
      end;
    end;

    punktide_tabel[tmp_j]:=punktide_tabel[pr_i]; {vahetatakse kohad tabeli}
    punktide_tabel[pr_i]:=cur_p;
  end;
end;

procedure getminmax; {saadakse minimaalsed ja maksimaalsed punktid tabelis}
var
  pr_i:integer;
begin
  min_punktid:=10000;
  max_punktid:=0;
  for pr_i:=1 to 23 do {leitakse min ja max}
  begin
    if punktide_tabel[pr_i].punktid<min_punktid then
    begin
      min_punktid:=punktide_tabel[pr_i].punktid; {min_punktid saab uue väärtuse}
      min_koht:=pr_i;
    end;
    if punktide_tabel[pr_i].punktid>max_punktid then max_punktid:=punktide_tabel[pr_i].punktid; {max_punktid saab uue väärtuse}
  end;
end;

procedure obj_uss.pause(onoff:boolean);
begin
  pause_on:=onoff;
  if pause_on then OutTextXY(akna_x+200, akna_y-12, 'Paus')
    else Bar(akna_x+200, akna_y-20, akna_x+250, akna_y-3); {näidtatakse ekraanl paus teadet, või kustutatakse see}
end;

procedure show_punktid;
var
  pr_i:integer;
  rida_y:integer; {rea y-koht ekraanil}
  punktid_str:string;
  sammud_str:string;
  koht_str:string;
  akna_y:integer;
begin
  akna_y:=30;
  puhasta_ekraan;
  j_tavaline_aken(1, 20, 630, 450, 'Punktide tabel'); {joonistatakse algus ekraan}

  OutTextXY(20, akna_y+15,'Koht');
  OutTextXY(60, akna_y+15,'Nimi');
  OutTextXY(170, akna_y+15,'Punktid');
  OutTextXY(240, akna_y+15,'Sammud');

  jarjesta_tabel; {punktide tabel järjestatakse}

  rida_y:=akna_y+35;
  for pr_i:=1 to max_punktide_tabel do {punktide faili toomine ekraanile}
  begin
    str(punktide_tabel[pr_i].punktid, punktid_str);
    str(punktide_tabel[pr_i].sammud, sammud_str);
    str(pr_i, koht_str);
    OutTextXY(20, rida_y, koht_str+'.');                   {koht}
    OutTextXY(60, rida_y, copy(punktide_tabel[pr_i].nimi, 1, 13));      {nimi}
    OutTextXY(170, rida_y, punktid_str);                   {punktid}
    OutTextXY(240, rida_y, sammud_str);                    {sammud}
    rida_y:=rida_y+15;
  end;

  readkey;
end;

procedure obj_uss.loe_nimi;{loeb nime ekraanilt}
var
  pr_ch:char;
  tmp:string;
begin
  pr_ch:=' ';
  tmp:='';
  while pr_ch<>#13 do
  begin
    pr_ch:=ReadKey;
    if pr_ch<>#13 then
    begin
      tmp:=tmp+pr_ch;
      OutText(pr_ch);
    end;
  end;
  nimi:=tmp;
end;

procedure obj_uss.arvuta_aeg;
begin
  aeg:=round(aeg/aeg_k);
end;

function obj_uss.check_asi_ok:boolean; {kontrollib ega joonistatud asi pole ussi peal}
var
  pr_i:integer;
begin
  check_asi_ok:=true;
  for pr_i:=1 to cur_pikkus do
  begin
    if (uss[pr_i].x=asi.x) and (uss[pr_i].y=asi.y) then check_asi_ok:=false;
  end;
  if (asi.x<=akna_x) or (asi.x>=akna_x+akna_l) or (asi.y<=akna_y) or (asi.y>=akna_y+akna_k) then check_asi_ok:=false;
end;

function obj_uss.check_asi:boolean;
var
  test:boolean;
begin
  test:=(uss[1].x>=asi.x) and (uss[1].x<=asi.x+k_laius);
  check_asi:=test and (uss[1].y>=asi.y) and (uss[1].y<=asi.y+k_korgus);
end;

procedure obj_uss.m_kujund(alg_koht, lopp_koht:koordinaadid);
begin
  SetFillStyle(1, 0);
  Bar(alg_koht.x, alg_koht.y, alg_koht.x+k_laius, alg_koht.y+k_korgus);
  Rectangle(lopp_koht.x, lopp_koht.y, lopp_koht.x+k_laius, lopp_koht.y+k_korgus);
end;

procedure obj_uss.j_aken;
begin
  Line(akna_x, akna_y-2, akna_x+akna_l, akna_y-2);
  OutTextXY(akna_x+10, akna_y-12, 'Punktid: 0');
  OutTextXY(akna_x+100, akna_y-12, 'Sammud: 0');
  Rectangle(akna_x, akna_y, akna_x+akna_l, akna_y+akna_k);
end;

function obj_uss.check_key:boolean;
begin
  if KeyPressed then
  begin
    key:=ReadKey;
    check_key:=true;
  end
  else check_key:=false;
end;

procedure obj_uss.start;
begin
  key:='x';
  asi_steps:=5;
  asi_olemas:=false;
  cur_steps:=0;
  aeg_k:=1.05;
  punktid:=0;
  sammud:=0;
  turbo_key:='t';
  turbo_on:=false;
  pause_key:='p';
  pause_on:=false;
  sounds_on:=true;
  sound_on:=false;
  g_over:=false;

  SetColor(15);
  j_aken; {joonistame akna}
  uss[1].x:=akna_x+18;
  uss[1].y:=38;

  cur_pikkus:=1;

  aeg:=100;
  suund:=p;
  tmp_suund:=p;
end;

procedure obj_uss.move_uss;
var
  tmpcoord:koordinaadid;
  curcoord:koordinaadid;
  pr_i:integer;{private i}
  lstcoord:koordinaadid;
  punktid_str:string;
  sammud_str:string;

begin
  if sound_on then
  begin
    NoSound; {kui mingit äält tehti, siis nüüd lülitatakse see välja}
    sound_on:=false;
  end;

  if sounds_on then Sound(200); {tehakse häält}

  inc(sammud);     {suurendame kõigi sammude arvu}
  inc(cur_steps);  {suurendame sammude arvu}

  Bar(akna_x+100, akna_y-3, akna_x+600, akna_y-15);
  str(sammud, sammud_str);
  OutTextXY(akna_x+100, akna_y-12, 'Sammud: ' +sammud_str);

  if cur_steps>=asi_steps then {kontrollitakse, kas vaja joonistada uus asi}
  begin
    if not(asi_olemas) then j_asi;
    while not(check_asi_ok) do j_asi;
    cur_steps:=0; {nullitakse loendur}
    asi_olemas:=true;
  end;

  curcoord:=uss[1];{esimese osa koordinaadid}

  case suund of    {muudetakse esimese osa koordinaate}
    y:curcoord.y:=curcoord.y-aste-1;
    a:curcoord.y:=curcoord.y+aste+1;
    p:curcoord.x:=curcoord.x+aste+1;
    v:curcoord.x:=curcoord.x-aste-1;
  end;{case suund}

  tmpcoord:=uss[1];           {tmp saab väärtuseks esimese osa algsed koordinaadid}
  m_kujund(uss[1], curcoord); {liigutatakse esimest osa}
  uss[1]:=curcoord;

  for pr_i:=2 to cur_pikkus do
  begin
    lstcoord:=uss[pr_i];
    m_kujund(uss[pr_i], tmpcoord);
    uss[pr_i]:=tmpcoord;
    tmpcoord:=lstcoord;
  end;

  delay(5);                  {vajalik viivitus kiire arvuti puhul}
  if sounds_on then NoSound; {hääl pannakse kinni}

  if check_asi then
  begin
    if sounds_on then Sound(440); {võidu hääl :)}
    delay(50);
    sound_on:=sounds_on;
    arvuta_aeg;
    asi_olemas:=false;
    asi.x:=0;
    asi.y:=0;
    inc(cur_pikkus);
    uss[cur_pikkus]:=tmpcoord;
    inc(punktid);
    str(punktid, punktid_str);
    Bar(akna_x+10, akna_y-15, akna_x+100, akna_y-3);
    OutTextXY(akna_x+10, akna_y-12, 'Punktid: ' +punktid_str);
  end;

  if check_game then mang_labi_teade;

end;

function obj_uss.check_game:boolean;{kontrollib kas mäng kaotatud}
var
  test:boolean;
begin
  test:=(uss[1].x<=akna_x) or (uss[1].y<=akna_y);
  test:=test or (uss[1].y>=akna_y+akna_k) or (uss[1].x>=akna_x+akna_l);
  if test then check_game:=true
    else check_game:=false;
end;

procedure obj_uss.mang_labi_teade;{teade, kui mäng kaotatud}
begin
  Rectangle(akna_x+50, akna_y+50, akna_x+240, akna_y+100);
  OutTextXY(akna_x+60, akna_y+60, mang_labi_text);

  if sounds_on then Sound(1000); {kaotuse hääl :(}
  delay(1000);                   {sekund viivitust}
  if sounds_on then NoSound;     {hääl kinni}

  if punktid>min_punktid then {kui punktide arv suurem viimasest(tabelis), või}
  begin                       {tabelis vaba koht, siis lisatakse mängija nimi tabelisse}
    MoveTo(akna_x+60, akna_y+80); OutText('Sisesta nimi: '); loe_nimi;

    pkirje.nimi:=nimi;
    pkirje.sammud:=sammud;
    pkirje.punktid:=punktid;
    pkirje.aeg_k:=aeg_k;

    punktide_tabel[min_koht]:=pkirje {lisame punktid tabelisse}
  end;

  g_over:=true;
end;

procedure obj_uss.j_asi;{joonistatakse midagi, mida korjata}
var
  xmod, ymod:integer;
begin
  Randomize;

  asi.x:=akna_x+round(Random(akna_l+akna_x));
  asi.y:=akna_y+round(Random(akna_k+akna_y));

  xmod:=(asi.x-akna_x) mod 6;
  asi.x:=asi.x+6-xmod;

  ymod:=(asi.y-akna_y) mod 6;
  asi.y:=asi.y+6-ymod;

  Rectangle(asi.x, asi.y, asi.x+k_laius, asi.y+k_korgus);
end;

procedure obj_uss.set_suund;
begin
  tmp_suund:=suund;
  if key=y_key then suund:=y;
  if key=v_key then suund:=v;
  if key=p_key then suund:=p;
  if key=a_key then suund:=a;
end;

procedure obj_uss.k_kujund(coord:koordinaadid);{kujundi kustutamine}
begin
  SetFillStyle(1, 0);
  Bar(coord.x, coord.y, coord.x+k_laius, coord.y+k_korgus);
end;{k_kujund}

procedure show_game_settingud; {näitab mängu settinguid ja vajadusel muudetakse neid}
var
  setmenuu:obj_menuu; {settingute tabel lahendatud menüü opjektiga}
  pr_ch:char;
begin
  puhasta_ekraan;
  j_tavaline_aken(1, 20, 630, 450, 'Mängu settingud'); {joonistatakse aken}
  setmenuu.start;
  setmenuu.lisa_valik('1. Kujundi suurus');
  setmenuu.lisa_valik('2. Hääled');
  setmenuu.lisa_valik('3. Kiirus');
  setmenuu.lisa_valik('4. Välju');
  setmenuu.joonista(20, 40);
  setmenuu.tee_valik;
end;

procedure kaks_mangijat; {kahe mängijaga mäng}
var
  uss1, uss2:obj_uss;
  key:char;
  all_delay:integer;
  vahe_delay:integer;
begin
  mangutyyp:=2; {mängutüüp: kahekesi}
  puhasta_ekraan;
  SetColor(15);
  getminmax;

  uss1.akna_x:=1;
  uss1.akna_y:=20;
  uss1.akna_l:=300;
  uss1.akna_k:=450;

  uss1.y_key:='i';
  uss1.a_key:='m';
  uss1.p_key:='l';
  uss1.v_key:='j';

  uss2.y_key:='e';
  uss2.a_key:='x';
  uss2.p_key:='f';
  uss2.v_key:='s';

  uss2.akna_x:=320;
  uss2.akna_y:=20;
  uss2.akna_l:=300;
  uss2.akna_k:=450;

  uss1.start;
  uss2.start;

  repeat
    if keypressed then
    begin
      key:=readkey;
      uss1.key:=key;
      uss2.key:=key;

      uss1.set_suund;
      uss2.set_suund;
    end;{if keypressed}

    uss1.move_uss;
    uss2.move_uss;

    if uss1.aeg>uss2.aeg then all_delay:=uss1.aeg
      else  all_delay:=uss2.aeg;

    delay(all_delay);
  until uss1.g_over or uss2.g_over or (uss1.key=#27); {mäng käib kuni esimene kasutaja vajutab <esc>'i}
end;

procedure yks_mangija; {ühe mängijaga mäng}
var
  uss:obj_uss;
begin
  mangutyyp:=1;     {mängutüüp: üksinda}
  puhasta_ekraan;
  SetColor(15);
  getminmax;        {saadakse min ja max punktid}
  uss.akna_x:=1;    {akna mõtmed: peavad olema enne uss.start käivitamist}
  uss.akna_y:=20;
  uss.akna_l:=630;  {laius}
  uss.akna_k:=450;  {kõrgus}
  uss.start;
  uss.y_key:='i';
  uss.a_key:='m';
  uss.p_key:='l';
  uss.v_key:='j';
  repeat
    if uss.check_key then
    begin
      uss.set_suund;
      if (uss.key=uss.turbo_key) and not(uss.turbo_on) then uss.turbo_on:=true
        else uss.turbo_on:=false;
      if uss.key=uss.pause_key then
      begin
        if uss.pause_on then uss.pause(false)
          else uss.pause(true);
      end;
    end;
    if not(uss.pause_on) then uss.move_uss; {kui pole paus, siis liigutatakse ussi}
    if uss.turbo_on then delay(round(uss.aeg/10))
      else delay(uss.aeg);
  until uss.g_over or (uss.key=#27); {mäng käib kuni uss seinas või kasutaja vajutab <esc>'i}

  puhasta_ekraan;   {tühjendatakse ekraan}
  show_punktid;     {näidatakse punktitabelit}
end;

begin

grd:=detect;
InitGraph(grd, grm,'');{graafika initsialiseerimine}

for p_i:=1 to max_punktide_tabel do
begin
  punktide_tabel[p_i].punktid:=0;          {tabeli punktid võrdsustetakse 0-ga}
  punktide_tabel[p_i].nimi:='sinu nimi';   {nimedele antakse väärtused}
  punktide_tabel[p_i].sammud:=0;           {sammud võrdsustatakse 0-ga}
end;

assign(pfile, punktide_fail);{avatakse punktide fail}
reset(pfile);
if FileSize(pfile)>0 then read(pfile, punktide_tabel); {kui fail suurem kui 0, siis loetakse sealt punktide tabel}


repeat
  puhasta_ekraan;
  getminmax;{saadakse min ja max punktid}
  j_tavaline_aken(1, 20, 630, 450, 'TurboUss v1.0'); {joonistatakse algus ekraan}
  algmenuu.start;
  algmenuu.lisa_valik('1. Üks mängija');
  algmenuu.lisa_valik('2. Kaks mängijat');
  algmenuu.lisa_valik('3. Settingud');
  algmenuu.lisa_valik('4. Punktide tabel');
  algmenuu.lisa_valik('5. Välju');
  algmenuu.joonista(20, 40);
  algmenuu.tee_valik;
  case algmenuu.valik of
    1:yks_mangija;         {mäng ühe mängijaga}
    2:kaks_mangijat;       {mäng kahe mängijaga}
    4:show_punktid;        {punktide tabeli näitamine}
    3:show_game_settingud; {näidatakse settinguid}
  end;{case algmenuu.valik}
until algmenuu.valik=5;

CloseGraph;                   {graafikamode'i sulgemine}

seek(pfile, 0);               {punktide failis liigutakse algusesse ja}
write(pfile, punktide_tabel); {punktide tabel kirjutatakse uuesti faili}
close(pfile); {sulgeme punktide faili}
end.
