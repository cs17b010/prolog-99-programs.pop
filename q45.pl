:- ensure_loaded(p6_01).  
:- ensure_loaded(p6_02). 

degree(graph(Ns,Es),Node,Deg) :- 
   alist_gterm(graph,AList,graph(Ns,Es)),
   member(n(Node,AdjList),AList), !,
   length(AdjList,Deg).


degree_sorted_nodes(graph(Ns,Es),DSNodes) :- 
   alist_gterm(graph,AList,graph(Ns,Es)),  
   predsort(compare_degree,AList,AListDegreeSorted),
   reduce(AListDegreeSorted,DSNodes).

compare_degree(Order,n(N1,AL1),n(N2,AL2)) :-
   length(AL1,D1), length(AL2,D2),
   compare(Order,D2+N1,D1+N2).


reduce([],[]).
reduce([n(N,_)|Ns],[N|NsR]) :- reduce(Ns,NsR).



paint(Graph,ColoredNodes) :-
   degree_sorted_nodes(Graph,DSNs),
   paint_nodes(Graph,DSNs,[],1,ColoredNodes).


paint_nodes(_,[],ColoNodes,_,ColoNodes) :- !.
paint_nodes(Graph,Ns,AccNodes,Color,ColoNodes) :-
   paint_nodes(Graph,Ns,Ns,AccNodes,Color,ColoNodes).
   

paint_nodes(Graph,Ns,[],AccNodes,Color,ColoNodes) :- !,
   Color1 is Color+1,
   paint_nodes(Graph,Ns,AccNodes,Color1,ColoNodes).
paint_nodes(Graph,DSNs,[N|Ns],AccNodes,Color,ColoNodes) :- 
   \+ has_neighbor(Graph,N,Color,AccNodes), !,
   delete(DSNs,N,DSNs1),
   paint_nodes(Graph,DSNs1,Ns,[c(N,Color)|AccNodes],Color,ColoNodes).
paint_nodes(Graph,DSNs,[_|Ns],AccNodes,Color,ColoNodes) :- 
   paint_nodes(Graph,DSNs,Ns,AccNodes,Color,ColoNodes).
   
has_neighbor(Graph,N,Color,AccNodes) :- 
   adjacent(N,X,Graph),
   memberchk(c(X,Color),AccNodes).
