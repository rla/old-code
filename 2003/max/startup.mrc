;Trivia startup

on 1:START:{
  if (%esimestkorda == 1) { 
    set %server $$?="Sisesta serveri nimi."
    set %nimi $$?="Sisesta oma nimi."
    set %ident $$?="Sisesta nime parool."
    set %kanal $$?="Sisesta kanal."
  }
  server %server
  set %esimestkorda 0
  nick %nimi
}
on 1:CONNECT:{
  ns identify %ident
  .timer 1 4 join %kanal
}
on 1:JOIN:#:{
  if ($nick == $me) { 
    start
    settingud
  }
  else {
    .notice $nick Kanalis toimivad käsud: !points, !top10, !top, !ping
  }
}
