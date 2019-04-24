:- ensure_loaded(p6_01).  
:- ensure_loaded(p6_02).  

depth_first_order(Graph,Start,Seq) :- 
   (Graph = graph(Ns,_), !; Graph = digraph(Ns,_)),
   memberchk(Start,Ns),
   clear_rdb(dfo),
   recorda(dfo,Start),
   (dfo(Graph,Start); true),
   bagof(X,recorded(dfo,X),Seq).

dfo(Graph,X) :-
   adjacent(X,Y,Graph), 
   \+ recorded(dfo,Y),
   recordz(dfo,Y),
   dfo(Graph,Y).

clear_rdb(Key) :-
   recorded(Key,_,Ref), erase(Ref), fail.
clear_rdb(_).


