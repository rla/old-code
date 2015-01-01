program kirje;

uses crt,dos;

  type isik=record
              ees,pere:string[80];
              isikukood:string[11];
            end;

  var is:isik;
    lfail:file of isik;
    chh:char;
    ch:char;
    cch:char;
    cchh:char;
    chek:char;
    i:byte;
    kuu,kuuc:string[4];


begin
TextBackground(0);
ch:=#0;

repeat
  clrscr;
  writeln('ANDMETÖÖTLUS':40); writeln; writeln;
  writeln('Lõpetamiseks "ESC"':40); writeln;
  writeln('     <1> Lähtefaili moodustamine');
  writeln('     <2> Andmete vaatamine');
  writeln;
  write('Valik : ');
  ch:=readkey;
  write(ch);
  case ch of
  '1':begin
      clrscr;
      writeln('LÄHTEFAILI MOODUSTAMINE':40);
      writeln; writeln; writeln;
      writeln('Lõputunnus : eesnimi #####':40);
      writeln('Eesnimi':15);
      writeln('Perekoonanimi':15);
      writeln('Isikukood':15);
      assign(lfail,'kirje.is');
{$I-}{sisestamis väljastamisoperatsioonide osa välja}
      reset(lfail);
      if ioResult = 0 then begin Sound(800); gotoXY(3,3); write('Soovite <l>lisada või <t>tekitada');
       chh:=readkey;
       NoSound;
       write(chh);
       case chh of
        'l','L':seek(lfail,filesize(lfail));
        't','T':rewrite(lfail);
        end;
      end
      else rewrite(lfail);
      gotoXY(3,3); writeln(' ':40);
{I+}
      repeat
      for i:=1 to 6 do
        begin
        GotoXY(17,i+5);
        writeln(' ':25);
        end;
        GotoXY(17,6);
        readln(is.ees);
        if is.ees<>'#####' then
          begin
          GotoXY(17,7);
          readln(is.pere);
          GotoXY(17,8);
          readln(is.isikukood);
          end;
      if is.ees<>'#####' then write(lfail,is);
      until is.ees='#####';
      close(lfail);
      end;
    '2':begin
        repeat
        clrscr;
        assign(lfail,'kirje.is');
        reset(lfail);
        writeln('ANDMETE VAATAMINE':40);
        writeln;
        writeln('<t> Tüdrukud');
        writeln('<p> Poisid');
        writeln('<k> Kõik');
        cchh:=readkey;
        chek:='0';
        writeln;
        if cchh='t' then begin chek:='4'; writeln('Tüdrukud :'); end;
        if cchh='p' then begin chek:='3'; writeln('Poisid :'); end;
        if cchh='k' then  writeln('Kõik :');
        write('Mitmendal kuul(k:kõik) :'); readln(kuu);
        writeln;
        i:=0;
        repeat
          seek(lfail,i);
          read(lfail,is);
          if (cchh<>'p') and (cchh<>'t') then
          begin
          if kuu='k' then
            begin
            write(is.ees:10);
            write(is.pere:13);
            writeln(is.isikukood:12);
            end
            else
              begin
              kuuc:=is.isikukood[4]+is.isikukood[5];
              if kuuc=kuu then
                begin
                write(is.ees:10);
                write(is.pere:13);
                writeln(is.isikukood:12);
                end;
              end;
          end;
          if is.isikukood[1] = chek then begin
          if kuu='k'then
            begin
            write(is.ees:10);
            write(is.pere:13);
            writeln(is.isikukood:12);
            end
            else
              begin
              kuuc:=is.isikukood[4]+is.isikukood[5];
              if kuuc=kuu then
                begin
                write(is.ees:10);
                write(is.pere:13);
                writeln(is.isikukood:12);
                end;
              end;
          end;
          i:=i+1;
        until i=filesize(lfail);
        writeln;
        writeln;
        writeln('Väljumiseks "ESC"');
        cch:=readkey;
        until cch=#27;
        close(lfail);
        end;
    else writeln('ffff');
  end;


until ch=#27;
end.