;Max
menu Channel,menubar {
  -
  &Kaima:/start
  &Kinni:/stop
  -
  &Kanal:/set %botchan $$?="Sisesta kanali nimi"
  -
  Identi pass:/set %inpass $$?="Sisesta parool"  
}
alias start {
  msg %botchan Trivia on alanud!
  .timer302 1 3 kysimus  
}
alias stop {
  msg %botchan Trivia on lõppenud!
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
  msg %botchan Uus küsimus
  msg %botchan $+ %kyssa
  .timer909 1 30 aegotsas
}
alias aegotsas {
  msg %botchan Aeg läbi! Vastust ei teadnud keegi!
  unset %kyssa
  .timer102 1 10 kysimus
}
alias oigevastus {
  if (%kyssa != $null) {
    msg %botchan Sul on õigus, $nick
    set %punktid $readini punktid.ini punktid $nick
    if (%punktid == $null) { set %punktid 1 }
    else { inc %punktid }
    writeini -n punktid.ini punktid $nick %punktid  
  }
  unset %kyssa
  .timer909 off
  .timer304 1 10 kysimus  
}
alias checktop10 {
  set %scr 1 
  set %top1score 0 | set %top2score 0 | set %top3score 0 | set %top4score 0 | set %top5score 0 | set %top6score 0 |  set %top7score 0 | set %top8score 0  | set %top9score  0 | set %top10score  0
  set %top1winr * | set %top2winr * | set %top3winr * | set %top4winr * |  set %top5winr * | set %top6winr * | set %top7winr * | set %top8winr * |  set %top9winr * | set %top10winr *
  :next
  %scr2 =  $read -l $+ %scr punktid.ini
  %len1 = $len(%scr2)
  if ( $pos(%scr2,=,1) == $null ) {  goto nxt }
  %pos1 = $pos(%scr2,=,1)
  %right1 =  %len1 - %pos1 | %left1 = $calc(%len1 - %right1 - 1)
  %scrnick = $left(%scr2,%left1) |  %scrchk = $right(%scr2,%right1)
  if ( $abs(%scrchk) == 0 ) { goto nxt }
  if ( %scrchk >= %top1score ) { %top10score = %top9score |  %top9score = %top8score | %top8score = %top7score |  %top7score = %top6score | %top6score = %top5score | %top5score = %top4score | %top4score = %top3score |  %top3score = %top2score |  %top2score = %top1score | %top1score = %scrchk | %top10winr = %top9winr |  %top9winr = %top8winr | %top8winr = %top7winr |  %top7winr = %top6winr | %top6winr = %top5winr | %top5winr = %top4winr | %top4winr = %top3winr |  %top3winr = %top2winr |  %top2winr = %top1winr | %top1winr = %scrnick |  inc %scr 1 |  goto next }
  if ( %scrchk >= %top2score ) { %top10score = %top9score |  %top9score = %top8score | %top8score = %top7score |  %top7score = %top6score | %top6score = %top5score | %top5score = %top4score | %top4score = %top3score |  %top3score = %top2score | %top2score = %scrchk |  %top10winr = %top9winr |  %top9winr = %top8winr | %top8winr = %top7winr |  %top7winr = %top6winr | %top6winr = %top5winr | %top5winr = %top4winr | %top4winr = %top3winr |  %top3winr = %top2winr |  %top2winr =  %scrnick |  inc %scr 1 |  goto next }
  if ( %scrchk >= %top3score ) { %top10score = %top9score |  %top9score = %top8score | %top8score = %top7score |  %top7score = %top6score | %top6score = %top5score | %top5score = %top4score | %top4score = %top3score |  %top3score  = %scrchk |  %top10winr = %top9winr |  %top9winr = %top8winr | %top8winr = %top7winr |  %top7winr = %top6winr | %top6winr = %top5winr | %top5winr = %top4winr | %top4winr = %top3winr |  %top3winr = %scrnick |  inc %scr 1 |  goto next }
  if ( %scrchk >= %top4score ) { %top10score = %top9score |  %top9score = %top8score | %top8score = %top7score |  %top7score = %top6score | %top6score = %top5score | %top5score = %top4score | %top4score  = %scrchk |  %top10winr = %top9winr |  %top9winr = %top8winr | %top8winr = %top7winr |  %top7winr = %top6winr | %top6winr = %top5winr | %top5winr = %top4winr | %top4winr = %scrnick |  inc %scr 1 |  goto next }
  if ( %scrchk >= %top5score ) { %top10score = %top9score |  %top9score = %top8score | %top8score = %top7score |  %top7score = %top6score | %top6score = %top5score | %top5score = %scrchk |  %top10winr = %top9winr |  %top9winr = %top8winr | %top8winr = %top7winr |  %top7winr = %top6winr | %top6winr = %top5winr | %top5winr =  %scrnick |  inc %scr 1 |  goto next }
  if ( %scrchk >= %top6score ) { %top10score = %top9score |  %top9score = %top8score | %top8score = %top7score |  %top7score = %top6score | %top6score =  %scrchk  | %top10winr = %top9winr |  %top9winr = %top8winr | %top8winr = %top7winr |  %top7winr = %top6winr | %top6winr =  %scrnick |  inc %scr 1 |  goto next }
  if ( %scrchk >= %top7score ) { %top10score = %top9score |  %top9score = %top8score | %top8score = %top7score |  %top7score =  %scrchk | %top10winr = %top9winr |  %top9winr = %top8winr | %top8winr = %top7winr |  %top7winr =  %scrnick |  inc %scr 1 |  goto next }
  if ( %scrchk >= %top8score ) { %top10score = %top9score |  %top9score = %top8score | %top8score =  %scrchk | %top10winr = %top9winr |  %top9winr = %top8winr | %top8winr =  %scrnick |  inc %scr 1 |  goto next }
  if ( %scrchk >= %top9score ) { %top10score = %top9score |  %top9score =  %scrchk |  %top10winr = %top9winr |  %top9winr =  %scrnick |  inc %scr 1 |  goto next }
  if ( %scrchk >= %top10score ) { %top10score  =  %scrchk | %top10winr  =  %scrnick |  inc %scr 1 |  goto next }
  :nxt 
  inc %scr 1 
  if $read -l $+ %scr punktid.ini == $null { saveini | return  }
  goto next
}
alias top10 {
  checktop10
  .msg $nick Top10  Trivia mängijad :
  .msg $nick Koht : Nimi : Punktid
  if (%top1winr != $null) { %topwinr.e = false | .msg $nick  1. %top1winr -- %top1score punkti }
  if (%top2winr != $null) { .msg $nick  2. %top2winr -- %top2score punkti }
  if (%top3winr != $null) { .msg $nick  3. %top3winr -- %top3score punkti }
  if (%top4winr != $null) { .msg $nick  4. %top4winr -- %top4score punkti }
  if (%top5winr != $null) { .msg $nick  5. %top5winr -- %top5score punkti }
  if (%top6winr != $null) { .msg $nick  6. %top6winr -- %top6score punkti }
  if (%top7winr != $null) { .msg $nick  7. %top7winr -- %top7score punkti }
  if (%top8winr != $null) { .msg $nick  8. %top8winr -- %top8score punkti }
  if (%top9winr != $null) { .msg $nick  9. %top9winr -- %top9score punkti }
  if (%top10winr != $null) { .msg $nick  10 %top10winr -- %top10score punkti }
  if (%topwinr.e == true) { .msg $nick the top10 is empty at this time }
}
on 1:TEXT:%vastus:%botchan:/oigevastus
on 1:TEXT:!points*:%botchan:{
  if ($2 == $null) {
    set %ptmp $readini punktid.ini punktid $nick
    if (%ptmp == $null) { msg %botchan $+ $nick sul ei ole punkte }
    if (%ptmp != $null) { msg %botchan $+ $nick sul on %ptmp punkti }
  }
  if ($2 != $null) && ($3 == $null) {
    set %nimi $2
    set %ptmp $readini punktid.ini punktid %nimi
    if (%ptmp == $null) { msg %botchan $+ %nimi $+ 'l ei ole punkte }
    if (%ptmp != $null) { msg %botchan $+ %nimi $+ 'l on %ptmp punkti }
  }
}
on 1:TEXT:!ping:%botchan:{ 
  ctcp $nick ping
  set %start $ticks
}
on 1:TEXT:!top10:%botchan:{ top10 }
on 1:CTCPREPLY:PING* {
  ;if ($2 == $null) halt
  ;else {
  ;%pt = $ctime - $2
  ; msg %botchan $nick ping on %pt sekundit
  ;}
  set %finish $ticks
  set %respond $calc((%finish - %start) / 1000)
  msg %botchan $nick ping on %respond sekundit
}
on 1:START:/server world.estirc.net
on 1:CONNECT:{
  ns identify %inpass
  .timer 1 4 join %botchan
}
on 1:JOIN:#:{
  if ($nick == $me) start
}
on 1:TEXT:*munn*:#:/roppkick
on 1:TEXT:*sitt*:#:/roppkick
on 1:TEXT:*pask*:#:/roppkick
on 1:TEXT:*pede*:#:/roppkick
on 1:TEXT:*vitt*:#:/roppkick
on 1:TEXT:*türa*:#:/roppkick
on 1:TEXT:*tyrapea*:#:/roppkick
on 1:TEXT:*puts*:#:/roppkick
on 1:TEXT:*lits*:#:/roppkick
on 1:TEXT:*perva*:#:/roppkick
on 1:TEXT:*perse*:#:/roppkick
on 1:TEXT:*persse*:#:/roppkick
alias roppkick {
  if $nick isop # { halt }
  if $me isop # {
    ban -u5 # $nick
    .timer 1 3 kick # $nick "ropenda mujal" kick nr. %kicks
    inc %kicks
  }
}
on 1:TEXT:*tulge*#*:#:/reklkick
on 1:TEXT:*tlge*#*:#:/reklkick
alias reklkick {
  if $nick isop # { halt }
  if $me isop # {
    ban -u5 # $nick
    .timer 1 3 kick # $nick "mine ise..." kick nr. %kicks
    inc %kicks
  }
}
