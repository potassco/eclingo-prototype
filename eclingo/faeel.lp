%
% Preprocessing
%


% rule(head(H),B):
% * There is a rule with head H and body B
rule(head(H),B) :- rule(disjunction(H),B).
rule(head(H),B) :- rule(     choice(H),B).


%
% Main Encoding:
% * Determine the minimal model of the reduct of the program wrt.
%   the stable model guessed by metaD.lp, defining k(X) as follows:
%     k(X) :- X, true(atom(X)), Y : true(atom(Y)), Y < X.
%   The atoms true(atom(X)) and true(atom(Y)) are optional, can be 
%   added (deleted) with 
%     truex = 1 (0)
%   and
%     truey = 1 (0)
% * Note that we could also replace Y by k(Y):
%     k(X) :- X, true(atom(X)), k(Y) : true(atom(Y)), Y < X.
%   or try this:
%     k(X) :- X, true(atom(X)), Y < X, #false: Y < Z, Z < X;
%             1 { k(Y); fail(atom(Y)) }.
%
#const truex = 1.
#const truey = 1.

% same as in meta.lp, but not hold(L) was replaced by fail(atom(L))
conjunction(B) :- literal_tuple(B),
       hold(L) :  literal_tuple(B, L), L > 0;
 fail(atom(L)) :  literal_tuple(B,-L), L > 0.

% same as in meta.lp, but not hold(L) was replaced by fail(atom(L))
body(normal(B)) :- rule(_,normal(B)), conjunction(B).
body(sum(B,G))  :- rule(_, sum(B,G)),
    #sum { W,L :       hold(L), weighted_literal_tuple(B, L,W), L > 0 ;
           W,L : fail(atom(L)), weighted_literal_tuple(B,-L,W), L > 0 } >= G.

% A holds (when A is a not a knowledge atom)
hold(A) :- atom_tuple(H,A), true(atom(A)), not ktuple(_,A,_),
           rule(head(H),B), body(B).

% A holds (when A is       a knowledge atom)
hold(A) :- ktuple(_,A,B), hold(B), true(atom(B)) : truex = 1;
           hold(D) : ktuple(_,C,D),                truey = 0,
                     scc(SCC,A), level(A,LA),
                     scc(SCC,C), level(C,LC), LC < LA;
           hold(D) : ktuple(_,C,D), true(atom(D)), truey = 1,
                     scc(SCC,A), level(A,LA),
                     scc(SCC,C), level(C,LC), LC < LA.


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
% Saturate
%
hold(A) :- supp(A), not fact(A), bot.


%
% Activate
%
faeel.

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

