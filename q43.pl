depth_first_order(Graph,Start,Seq) :- 
   alist_gterm(_,Alist,Graph),
   clear_rdb(dfo),
   dfo(Alist,Start),
   bagof(X,recorded(dfo,X),Seq).

dfo(_,X) :- recorded(dfo,X).
dfo(Alist,X) :-
   \+ recorded(dfo,X),
   recordz(dfo,X),
   memberchk(n(X,AdjNodes),Alist),
   Pred =.. [dfo,Alist],        % see remark below
   checklist(Pred,AdjNodes).

clear_rdb(Key) :-
   recorded(Key,_,Ref), erase(Ref), fail.
clear_rdb(_).
