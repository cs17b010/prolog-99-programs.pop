:- ensure_loaded(p6_01). 
:- ensure_loaded(p6_09). 



is_bipartite(G) :- 
   connected_components(G,Gs),
   checklist(is_bi,Gs).

is_bi(graph(Ns,Es)) :- Ns = [N|_], 
   alist_gterm(_,Alist,graph(Ns,Es)),
   paint(Alist,[],red,N).



paint(_,CNs,Color,N) :-  
   memberchk(c(N,Color),CNs), !.
paint(Alist,CNs,Color,N) :- 
   \+ memberchk(c(N,_),CNs),
   other_color(Color,OtherColor),
   memberchk(n(N,AdjNodes),Alist),
   Pred =.. [paint,Alist,[c(N,Color)|CNs],OtherColor],
   checklist(Pred,AdjNodes).

other_color(red,blue).
other_color(blue,red).
