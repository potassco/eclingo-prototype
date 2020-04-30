% L1 is the number of k(A) and L2 is the number of A (or x if A does not appear)
ktuple(A,L1,L2) :- output(k(A),B1), literal_tuple(B1,L1),
                   output(  A ,B2), literal_tuple(B2,L2).
ktuple(A,L1, x) :- output(k(A),B1), literal_tuple(B1,L1), not output(A,_).

% check errors
#show error(1,k(A)) : ktuple(A,L1,L2), 1 { L1<0; L2<0 }.
#show error(2,k(A)) : output(k(A),B1),               { literal_tuple(B1,L1) } != 1.
#show error(3,k(A)) : output(k(A),B1), output(A,B2), { literal_tuple(B2,L2) } != 1.

% generate knowledge atoms
k(hold(L2,1)) :- ktuple(A,L1,L2), hold(L1,1).

%
% Assign levels to knowledge atoms (per SCC)
%

% kscc(C,N): C is a scc with N knowledge atoms (N>0)
kscc(C,N) :- scc(C,_), N = #sum{ 1,A: scc(C,A), ktuple(_,A,_) }, N>0.

% level(A,L):
% * the level of knowledge atom A is L
{ level(A,L) : scc(C,A), ktuple(_,A,_) } = 1 :- kscc(C,N), L=1..N.
:- { level(A,LA) } != 1, scc(C,A), ktuple(_,A,_), kscc(C,_).

% Preliminary:
% * Consider an scc named faeel that contains all knowledge atoms
%
scc(faeel,A) :- ktuple(_,A,_).

% generate k(level()) atoms to pass to the checker
k(level(A,L)) :- level(A,L).

% just one model
model(1).

% display
#show.
#show T : output(T,B), conjunction(B,1).
