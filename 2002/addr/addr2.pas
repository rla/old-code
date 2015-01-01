program addrots2;
uses crt,addrfail;
const setfail='settings.ini';
  var fnimi:string;
      kask:char;
      ffset:text;
label algus;
label lopp;
begin
algus:
clrscr;
fnimi:='addr.txt';
MenyOsa('Kasuta suvalist faili');
MenyOsa('Standard faili(addr.txt)');
MenyOsa('Tee kompresseeritud fail');
MenyOsa('Eelmise kompresseeritud faili kasutamine');
MenyOsa('Välju');
kask:=readkey;
case kask of
  'k':begin write('Sisesta faili nimi : '); readln(fnimi); end;
  's':writeln;
  't':begin write('Sisesta kompresseeritava faili nimi : '); readln(fnimi); end;
  'e':fnimi:=GetFTExt(setfail,1);
  'v':goto lopp;
  else begin writeln('Vajutasid vale tähe või oli CapsLock peal!'); writeln('Vajuta nüüd Enterit'); goto algus; end;
end;{case lõpp}
DelEkraan;
writeln('Faili ',fnimi,' ridade arv on : ',RidadeArv(fnimi));
delay(500);

if kask='s' then begin Otsing(fnimi); VarvOsa('Tee kompresseeritud fail(j)','j'); kask:=readkey;
  if kask='j' then KirTextSetF(setfail,1,DelKorduvad(fnimi)); end;
if kask='e' then Otsing(fnimi);
if kask='k' then Otsing(fnimi);
if kask='t' then KirTextSetF(setfail,1,DelKorduvad(fnimi));

writeln;
writeln;
VarvOsa('Algusesse?(j)','j'); kask:=readkey;
if kask='j' then goto algus;
lopp:
end.