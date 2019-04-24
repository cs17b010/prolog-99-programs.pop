connected_components(graph([],[]),[]) :- !.
connected_components(graph(Ns,Es),[graph(Ns1,Es1)|Gs]) :-
   Ns = [N|_],
   component(graph(Ns,Es),N,graph(Ns1,Es1)),
   subtract(Ns,Ns1,NsR),
   subgraph(graph(Ns,Es),graph(NsR,EsR)),
   connected_components(graph(NsR,EsR),Gs).

component(graph(Ns,Es),N,graph(Ns1,Es1)) :-
   depth_first_order(graph(Ns,Es),N,Seq),
   sort(Seq,Ns1),
   subgraph(graph(Ns,Es),graph(Ns1,Es1)).

subgraph(graph(Ns,Es),graph(Ns1,Es1)) :-
   subset(Ns1,Ns),
   Pred =.. [edge_is_compatible,Ns1],
   sublist(Pred,Es,Es1).

edge_is_compatible(Ns1,Z) :- 
   (Z = e(X,Y),!; Z = e(X,Y,_)),
   memberchk(X,Ns1), 
   memberchk(Y,Ns1). 
