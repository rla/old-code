;Max-Trivia script

alias start {
  msg %kanal %color $+ Trivia on alanud!
  .timer302 1 3 kysimus  
}

alias stop {
  msg %kanal %color $+ Trivia on lõppenud!
  .timers off
}

alias kysimus {
  set %tmp $read -n kyssad.txt
  set %kohttmp $pos(%tmp,*,1)
  set %koht $calc(%kohttmp - 1)
  set %vastkoht $calc(%kohttmp + 1)
  set %kyssa $left(%tmp,%koht)
  set %pikkus $len(%tmp)
  set %vastus $mid(%tmp,%vastkoht,%pikkus)
  msg %kanal %color $+ Uus küsimus
  msg %kanal %color $+ %kyssa
  .timer909 1 %timeout aegotsas
}

alias aegotsas {
  msg %kanal %color $+ Aeg läbi! Vastust ei teadnud keegi!
  unset %kyssa
  .timer102 1 %vaheaeg kysimus
}

alias oigevastus {
  if (%kyssa != $null) {
    msg %kanal %color $+ Sul on õigus, $nick
    set %punktid $readini punktid.ini punktid $nick
    if (%punktid == $null) { set %punktid 1 }
    else { inc %punktid }
    writeini -n punktid.ini punktid $nick %punktid  
  }
  unset %kyssa
  .timer909 off
  .timer304 1 %vaheaeg kysimus  
}

on 1:TEXT:%vastus:%kanal:oigevastus
