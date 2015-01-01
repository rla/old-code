;Trivia käsud

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

on 1:TEXT:!top10:%kanal:{
  checktop10
  .msg $nick %color $+ Top10  Trivia mängijad :   
  .msg $nick %color $+ Koht : Nimi : Punktid
  .msg $nick %color $+ 1. %top1winr -- %top1score punkti
  .msg $nick %color $+ 2. %top2winr -- %top2score punkti
  .msg $nick %color $+ 3. %top3winr -- %top3score punkti
  .msg $nick %color $+ 4. %top4winr -- %top4score punkti
  .msg $nick %color $+ 5. %top5winr -- %top5score punkti
  .msg $nick %color $+ 6. %top6winr -- %top6score punkti
  .msg $nick %color $+ 7. %top7winr -- %top7score punkti
  .msg $nick %color $+ 8. %top8winr -- %top8score punkti
  .msg $nick %color $+ 9. %top9winr -- %top9score punkti
  .msg $nick %color $+ 10 %top10winr -- %top10score punkti
}

on 1:TEXT:!points*:%kanal:{
  if ($2 == $null) {
    set %ptmp $readini punktid.ini punktid $nick
    if (%ptmp == $null) { msg %kanal %color $+ $nick sul ei ole punkte }
    if (%ptmp != $null) { msg %kanal %color $+ $nick sul on %ptmp punkti }
  }
  if ($2 != $null) && ($3 == $null) {
    set %nimi $2
    set %ptmp $readini punktid.ini punktid %nimi
    if (%ptmp == $null) { msg %kanal %color $+ %nimi $+ 'l ei ole punkte }
    if (%ptmp != $null) { msg %kanal %color $+ %nimi $+ 'l on %ptmp punkti }
  }
}

on 1:TEXT:!ping:%kanal:{ 
  ctcp $nick ping
  set %start $ticks
}

on 1:TEXT:!top:%kanal:{
  if (lenght(%url)>1) {
    msg %kanal %color $+ Trivia punktid addressil %url
  }
  else {
    notice $nick Trivia top pole tehtud
  }
}

on 1:CTCPREPLY:PING* {
  set %finish $ticks
  set %respond $calc((%finish - %start) / 1000)
  msg %kanal %color $+ $nick ping on %respond sekundit
}
