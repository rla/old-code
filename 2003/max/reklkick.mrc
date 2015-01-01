;Reklaamikick

alias reklkick {
  if $nick isop # { halt }
  if $me isop # {
    ban -u5 # $nick
    .timer 1 3 kick # $nick %color $+ "Reklaam keelatud" kick nr. %kicks
    inc %kicks
  }
}

#reklaamikick on

on 1:TEXT:*tulge*#*:#:/reklkick
on 1:TEXT:*tlge*#*:#:/reklkick

#reklaamikick end
