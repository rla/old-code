:- op(150,xfy,#).

paste(Atom,Atom) :- atomic(Atom), !.
paste(P#Q,PQ) :- !, paste(P,Pp), paste(Q,Qp), atom_concat(Pp,Qp,PQ).
paste(Fxy,XfY) :- Fxy=..[F,X,Y], paste(X,Xv), paste(Y,Yv), concat_atom([Xv,F,Yv],XfY).

