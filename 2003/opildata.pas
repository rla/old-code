program opil_andmebaas;
                       {sisseastujate andmebaas}
{$APPTYPE CONSOLE}

const
  regnimi='2003.rec';{andmebaasi registreerimis faili nimi}
  maxopil=35;{maksimaalne õpilaste arv klassis}
  klnimi='kool.kl';{klasside faili nimi}

type
  isik=record
       eesnimi:string[16];
       perenimi:string[16];
       isikuk:string[11];
       kl:string[3];
       intern:(jah, ei);
       end;{isik}

  opilane=record
          nimi:string[30];
          isikuk:string[11];
          intern:boolean;
          elukoht:string[50];
          end;{opilane}

  klass=array[1..maxopil] of opilane;{lõpu tunnus nimi #####}

var
  ch:char;
  tahestik:array [0..36] of char;

function getsona:string;
var
  chh:char;
  tmp:string;
begin
  tmp:='';
  repeat
  chh:=readkey;
  write(chh);
  if chh<>#13 then tmp:=tmp+chh;
  until chh=#13;
  writeln;
  getsona:=tmp;
end;{getsona}

procedure jarjestamine;{klassides nimede järjestamine}
var
  kool:file of klass;
  kl:klass;{järjestamata}
  kl2:klass;{järjestatud}
  koodEA: array [#0..#33] of char;
    (' ','-','a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','š','z','ž','t','u','v','õ','ä','ö','ü','x','y');
  koodAE:array[char] of char;
  nimi,enimi:string[30];
  jrk:1..maxopl;
  i:byte;

  procedure KooditabelAE;
  var
    ch:char;
  begin
    koodAE[' ']:=#0; koodAE['-']:=#1;
    for ch:='a' to 's' do koodAE[ch]:=chr((ord(ch))-ord('a')+2);
    for ch:='A' to 'S' do koodAE[ch]:=chr((ord(ch))-ord('A')+2);
    for ch:='t' to 'w' do koodAE[ch]:=chr((ord(ch))-ord('a')+2);
    for ch:='T' to 'W' do koodAE[ch]:=chr((ord(ch))-ord('A')+2);
    case ch of
      'š','Š':koodAE[ch]:=#21;
      'ž','Ž':koodAE[ch]:=#23;
      'z','Z':koodAE[ch]:=#22;
      'õ','Õ':koodAE[ch]:=#23;
      'ä','Ä':koodAE[ch]:=#23;
      'ö','Ö':koodAE[ch]:=#30;
      'ü','Ü':koodAE[ch]:=#31;
      'x','X':koodAE[ch]:=#32;
      'y','Y':koodAE[ch]:=#33;
    end;  {kodeerib arvutikeelest eesti keelde}

  procedure Jarjestaja;
  begin
  end;{järjestaja lõpp}

  procedure KooditabelEA;
  begin
  end;{kodeerib eesti keelest arvutikeelde}

  begin
  kooditabelAE;
  jrk:=1;
  while kl[jrk].nimi<>'#####' do
  begin
    nimi:=kl[jrk].nimi;
    enimi:='';
    for i:=1 to length(nimi) do
      enimi:=enimi+koodAE[nimi[i]];
    kl[jrk].nimi:=enimi;
    jrk:=jrk+1;
  end; {while'i lõpp}
  {KooditabelEA;}
end;{Paneb õpilased klassidesse}

begin
  assign(kool, klnimi);
  reset(kool);
  close(kool);
end;

procedure klvaatamine;{klasside nimekirjade vaatamine}
  procedure vaata(klch:char);
  var
    kool:file of klass;
    kl:klass;
    i,ii:integer;
  begin
    clrscr;
    writeln('Klassi ', klch, ' nimekiri'); writeln;
    assign(kool, klnimi);
    reset(kool);
    case klch of
      'a':i:=0;
      'b':i:=1;
      'c':i:=2;
    end;{case}
    seek(kool, i);    read(kool, kl);
    ii:=1;
    while kl[ii].nimi<>'#####' do
    begin
      writeln(kl[ii].nimi);
      inc(ii);
    end;
    close(kool);
    readkey;
  end;{vaata}
var
  chh:char;
begin
  repeat
    clrscr;
    writeln('Klassi nimekirja vaatamine');
    writeln('Sisesta klass'); writeln;
    chh:=readkey;
    if chh<>#27 then vaata(chh);
  until chh=#27;
end;{klvaatamine}

procedure kljaotamine;{klassidesse jaotamine}
var
  kool:file of klass;
  fm:file of isik;
  kl:klass;
  is:isik;
  nimi:string;
  i:integer;{nimi klassis}
  ii:integer;{nimi reg failis}
  chkl:char;{klassi täht}
begin
  write('Klassidesse jaotamine..');

  assign(kool, klnimi);
  rewrite(kool);

  assign(fm, regnimi);
  reset(fm);

  for chkl:='a' to 'c' do
  begin

    ii:=0;{koht klassis}
    i:=1;{nime koht klassis}

    while ii<FileSize(fm) do
    begin
      seek(fm, ii);{liigume registreerimisfailis edasi}
      read(fm, is);{loema kirje}
      if is.kl='10' +chkl then {kui sobiv klass}
      begin
        kl[i].nimi:=is.perenimi+' '+is.eesnimi;
        kl[i].isikuk:=is.isikuk;
        if is.intern=jah then kl[i].intern:=true;
        inc(i);{suurendame nime kohta}
      end;
    inc(ii);{asukkoht registreerimisfailis}
    end;
    kl[i].nimi:='#####';{klassi opilaste nimekirja lõpp}
    write(kool, kl);{kirjutame kl kooli faili}

  end;

  close(kool);
  close(fm);
  writeln('ok'); readkey;
end;{kljaotamine}

procedure registreerimine;{uus fail? lisada?}
  procedure lisa(uus:boolean);{andmete lisamine}
  var
    cch:char;
    is:isik;
    intern:char;
    fm:file of isik;
    isikuktmp:string;
  begin
    assign(fm, regnimi);
    if uus then rewrite(fm)
      else
      begin
      reset(fm);
      seek(fm, filesize(fm));
      end;
    repeat
    clrscr;
    writeln('Lisa uus nimi:(lõpetamiseks ttt)'); writeln; writeln;
    write('Eesnimi:'); is.eesnimi:=getsona;
    if is.eesnimi<>'ttt' then
    begin
      write('Perenimi:'); is.perenimi:=getsona;
      write('Isikokood:'); isikuktmp:=getsona;
      is.isikuk:=isikuktmp;{lisamuutuja kontrollimiseks}
      write('Klass:'); is.kl:=getsona;
      write('Internaat(j/e):'); intern:=readkey;
      case intern of
        'j','J':is.intern:=jah;
        'e','E':is.intern:=ei;
        else writeln('Viga');
      end;{case intern}
      if length(isikuktmp)<>11 then
      begin
        writeln; writeln('Isikukood, mille sisestasite on vale!');
        readkey;
      end;
      write(fm, is);
    end;
    until is.eesnimi='ttt';
    close(fm);
  end;{lisa}
var
  chr:char;
begin
  ch:='9';
  repeat
  clrscr;
  writeln('Uute nimede lisamine:'); writeln;
  writeln('1.Lisa nimi');
  writeln('2.Uus fail');
  writeln('<ESC>');
  chr:=readkey;
  case chr of
    '1':lisa(false);
    '2':lisa(true);
  end;{case chr}
  until chr=#27;
end;{registreerimine}

procedure vaatamine;
var
  fm:file of isik;
  cchh:char;
  is:isik;
  i:integer;
begin
  clrscr;
  assign(fm, regnimi);
  reset(fm);
  writeln('Andmete vaatamine'); writeln;
  writeln('Fail:' +regnimi); writeln;
  write('Eesnimi'); write('Perenimi':17); write('Isikukood':17); write('Klass':10); write('Internaat':15);
  writeln;
  writeln;
  i:=0;
  while i<FileSize(fm) do
  begin
    seek(fm, i);
    read(fm, is);
    gotoxy(60, wherey);
    case is.intern of
      jah:write('Jah');
      ei:write('Ei');
      else write('?');
    end;{case is.intern}
    gotoxy(47, wherey); write(is.kl);
    gotoxy(33, wherey); write(is.isikuk);
    gotoxy(17, wherey); write(is.perenimi);
    gotoxy(1, wherey); write(is.eesnimi);
    writeln;
    inc(i);
  end;
  close(fm);
  cchh:=readkey;
end;{vaatamine}

begin
  repeat
  clrscr;
  writeln('Õpilaste andmebaas'); writeln; writeln;
  writeln('1.Registreerimine');
  writeln('2.Nimekirja vaatamine');
  writeln('3.Klassidesse jaotamine');
  writeln('4.Klassi nimekirja vaatamine');
  writeln('<ESC>');
  ch:=readkey;
  case ch of
    '1':registreerimine;
    '2':vaatamine;
    '3':kljaotamine;
    '4':klvaatamine;
  end;{case ch}
  until ch=#27;
end.