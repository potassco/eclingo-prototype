%
% Assign levels to knowledge atoms (per SCC)
%

% kscc(C,N): C is a scc with N knowledge atoms (N>0)
kscc(C,N) :- scc(C,_), N = #sum{ 1,A: scc(C,A), ktuple(_,A,_) }, N>0.

% level(A,L):
% * the level of knowledge atom A is L
{ level(A,L) : scc(C,A), ktuple(_,A,_) } = 1 :- kscc(C,N), L=1..N.
:- { level(A,LA) } != 1, scc(C,A), ktuple(_,A,_), kscc(C,_).

%
% TO DO:
% - Take advantage of sccs of the input program given by --reify:
%   this would not work now because in the input program
%   the knowledge atoms do not belong to any scc
%
% Preliminary:
% * Consider an scc named faeel that contains all knowledge atoms
%
scc(faeel,A) :- ktuple(_,A,_).

