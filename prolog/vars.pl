inst([H|Ins], Vars, [SublistVals|Vals]):- nonvar(H), H = [_|_], inst(H, SublistVars, SublistVals), inst(Ins, Vars1, Vals), append(SublistVars, Vars1, Vars).
inst([H|T1], [H|T2], [value(H)|T3]):- var(H), inst(T1, T2, T3).
inst([H|T1], T2, [H|T3]):- nonvar(H), inst(T1, T2, T3).
inst([], [], []).