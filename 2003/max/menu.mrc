;Käskude menuu

alias uus {
  write Kyssad.txt $$?="Sisesta küsimus." $+ * $+ $$?="Sisesta vastus."
}

alias settingud {
  echo -a Settingud:
  echo -a -- Timeout: %timeout sek
  echo -a -- Vahe: %vaheaeg sek
  echo -a -- Värv: %color -----
  echo -a -- Server: %server
  echo -a -- Kanal: %kanal
  echo -a -- Nimi: %nimi
  echo -a -- Ident: %ident
  echo -a -- Url: %url
}

menu Channel,menubar {
  -
  &Käima:start
  &Kinni:stop
  -
  Uus küsimus:uus
  Punktid2HTML:run punktid2html.exe
  -
  Settingud
  .Ekraanile:settingud
  .Server:set %server $$?="Sisesta serveri nimi."
  .Kanal:set %kanal $$?="Sisesta kanali nimi."
  .Nimi:set %nimi $$?="Sisesta oma nimi."
  .Ident:set %ident $$?="Sisesta parool."
  .Url:set %url $$?="Sisesta punktide address." | settingud
  .-
  .Teksti värv
  ..Valge:set %color 00 | settingud
  ..Must:set %color 01 | settingud
  ..Tumesinine:set %color 02 | settingud
  ..Roheline:set %color 03 | settingud
  ..Punane:set %color 04 | settingud
  ..Pruun:set %color 05 | settingud
  ..Lilla:set %color 06 | settingud
  ..Orants:set %color 07 | settingud
  ..Kollane:set %color 08 | settingud
  ..Heleroheline:set %color 09 | settingud
  ..Sinine:set %color 10 | settingud
  ..Helesinine:set %color 11 | settingud
  ..Tumesinine:set %color 12 | settingud
  ..Roosa:set %color 13 | settingud
  ..Hall:set %color 14 | settingud
  ..Helehall:set %color 15 | settingud
  .Ajad
  ..Timeout
  ...5 sek:set %timeout 5 | settingud
  ...10 sek:set %timeout 10 | settingud 
  ...15 sek:set %timeout 15 | settingud
  ...20 sek:set %timeout 20 | settingud
  ...25 sek:set %timeout 25 | settingud
  ...30 sek:set %timeout 30 | settingud
  ...40 sek:set %timeout 40 | settingud
  ...60 sek:set %timeout 60 | settingud
  ..Vahe
  ...5 sek:set %vaheaeg 5 | settingud
  ...10 sek:set %vaheaeg 10 | settingud 
  ...15 sek:set %vaheaeg 15 | settingud
  ...20 sek:set %vaheaeg 20 | settingud
  -
  Abi:run notepad.exe abi.txt
}
