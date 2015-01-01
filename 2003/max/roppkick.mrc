;Roppkick

alias roppkick {
  if $nick isop # { halt }
  if $me isop # {
    ban -u5 # $nick
    .timer 1 3 kick # $nick %color $+ "ropendamine pole siin lubatud" kick nr. %kicks
    inc %kicks
  }
}

#roppkick on

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

#roppkick end
