

k_regular(K,N,graph(Nodes,Edges)) :-
   range(1,N,Nodes),                        
   maplist(mku(K),Nodes,UList),             
   k_reg(UList,0,Edges).

mku(K,V,u(V,K)).


k_reg([],_,[]). 
k_reg([u(_,0)|Us],_,Edges) :- !, k_reg(Us,0,Edges).   % no more unused edges
k_reg([u(1,UX)|Us],MinY,[e(1,Y)|Edges]) :- UX > 0,    % special case X = 1
   pick(Us,Y,MinY,Us1), !,                    % pick a Y
   UX1 is UX - 1,                             % reduce number of unused edges
   k_reg([u(1,UX1)|Us1],Y,Edges).
k_reg([u(X,UX)|Us],MinY,[e(X,Y)|Edges]) :- X > 1, UX > 0,
   pick(Us,Y,MinY,Us1),                       % pick a Y
   UX1 is UX - 1,                             % reduce number of unused edges
   k_reg([u(X,UX1)|Us1],Y,Edges).

pick([u(Y,UY)|Us],Y,MinY,[u(Y,UY1)|Us]) :- Y > MinY, UY > 0, UY1 is UY - 1.
pick([U|Us],Y,MinY,[U|Us1]) :- pick(Us,Y,MinY,Us1).
   


range(B,B,[B]).
range(A,B,[A|L]) :- A < B, A1 is A + 1, range(A1,B,L).

:- dynamic solution/1.



all_k_regular(K,N,_) :-
   retractall(solution(_)),
   k_regular(K,N,Graph),
   no_iso_solution(Graph),
   write(Graph), nl,
   assert(solution(Graph)),
   fail.
all_k_regular(_,_,Graphs) :- findall(G,solution(G),Graphs).

:- ensure_loaded(p6_06).  % load isomorphic/2


no_iso_solution(Graph) :-
   solution(G), isomorphic(Graph,G), !, fail.
no_iso_solution(_).


table(Max) :-  
   nl, write('K-regular simple graphs with N nodes'), nl,
   table(3,Max).

table(N,Max) :- N =< Max, !,
   table(2,N,Max),
   N1 is N + 1,
   table(N1,Max).
table(_,_) :- nl. 

table(K,N,Max) :- K < N, !,
   tell('/dev/null'),
   statistics(inferences,I1),
   all_k_regular(K,N,Gs),
   length(Gs,NSol),    
   statistics(inferences,I2),
   NInf is I2 - I1,
   told,
   plural(NSol,Pl),
   writef('\nN = %w  K = %w   %w solution%w  (%w inferences)\n',[N,K,NSol,Pl,NInf]),
   checklist(print_graph,Gs),
   K1 is K + 1,
   table(K1,N,Max).
table(_,_,_) :- nl.

plural(X,' ') :- X < 2, !.
plural(_,'s').

:- ensure_loaded(p6_01). 

print_graph(G) :- human_gterm(HF,G), write(HF), nl.
   
