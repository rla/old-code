sched(a,'AMWF').
sched(a,'CMWF').
sched(a,'DW').
day(Stud, Result):- sched(Stud,Day), atom_chars(Day,DayBreakDown), 
                     subtract(['M','T','W','TH','F'],DayBreakDown, Result).