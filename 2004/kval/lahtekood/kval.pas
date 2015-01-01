program kval;

{
Kvalifikatsioonieksam 2004
demo

Raivo Laanemets
}

{delphis kompileerides tahab APPTYPE direktiivi,
kylixi puhul vajalik pole}
{APPTYPE CONSOLE}

{cgi variant tahab html päise saatmist}
{DEFINE cgi}


uses sredarvd, arvdtbl;

var
  arv1, arv2: TSuurArv;

begin
  {$IFDEF cgi}
     write('Content-Type: text/html', chr(10), chr(10));
     writeln('<pre>');
  {$ENDIF}

  writeln('---PROGRAMMI ALGUS---'); writeln;


  {Arvude tabeli puhastamine (nullide kirjutamine)}
  atPuhasta;

  {arvude arv1 ja arv2 puhastamine}
  saTyhjendaArv(arv1);
  saTyhjendaArv(arv2);

  {arvude 'käsitsi' määramine kümnendkohtade kaupa}
  saSet10Arv(arv1, 0, 3);
  saSet10Arv(arv1, 1, 1);

  saSet10Arv(arv2, 3, 4);
  saSet10Arv(arv2, 4, 5);
  saSet10Arv(arv2, 0, 1);

  Randomize;

  {arvu arv1 muutmine negatiivseks}
  saNegArv(arv1);

  {arvu arv1 lisamine tabelisse}
  atLisa(arv1, 'a');

  {teise arvu lisamine tablisse}
  atLisa(arv2, 'b');

  {juhuslike arvude c ja z genereerimine tabelisse}
  atRandom('c');

  atRandom('z');



  {Arvude väljastamine tabelist}
  write('Arv a = '); atValjasta('a'); writeln;
  write('Arv b = '); atValjasta('b'); writeln;
  write('Arv c = '); atValjasta('c'); writeln;
  write('Arv z = '); atValjasta('z'); writeln;

  {Tehted}
  {a ja b korrutamine, tulemus salvestatakse arvu d}
  atKorruta('a', 'b', 'd');
  write('Tulemus a x b = '); atValjasta('d'); writeln;

  {b ja c korrutamine, tulemus arvu e}
  atKorruta('b', 'c', 'e');
  write('Tulemus b x c = e = '); atValjasta('e'); writeln;


  {z ja e korrutamine, tulemus arvu y}
  atKorruta('z', 'e', 'y');
  write('Tulemus z x e = '); atValjasta('y'); writeln;



  writeln;
  writeln('---PROGRAMMI L6PP---');

  {$IFDEF cgi}
     write('</pre>');
  {$ELSE}
     readln;
  {$ENDIF}
end. 
