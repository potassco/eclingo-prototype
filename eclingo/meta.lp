%
% Usage: clingo --output=reify --reify-sccs       FILES |  clingo -Wno-atom-undefined - meta.lp metaD.lp OPTIONS
%        clingo --output=reify --reify-sccs example1.lp |  clingo -Wno-atom-undefined - meta.lp metaD.lp
%

% The conjunction of k(A) is B1 and the one of A is B2
ktuple(A,B1,B2) :- output(k(A),B1),     output(A,B2).
ktuple(A,B1,xx) :- output(k(A),B1), not output(A, _).

% choose knowledge atoms
{ k(A) } :- ktuple(A,B1,B2).

% fix knowledge atoms in the models
:- ktuple(A,B1,B2), model(M), k(A), not conjunction(B1,M).
:- ktuple(A,B1,B2), model(M), not k(A), conjunction(B1,M).

% check false knowledge atoms in the models
:- ktuple(A,B1,B2), not k(A), conjunction(B2,M) : model(M).

% fix knowledge atoms in the counter model
bot :- ktuple(A,B1,B2),     k(A), fail(normal(B1)).
bot :- ktuple(A,B1,B2), not k(A), true(normal(B1)).

% check true knowledge atoms in the counter model
ok(A) :- ktuple(A,B1,B2), not k(A).
ok(A) :- ktuple(A,B1,B2), true(normal(B2)).
bot :- ok(A) : ktuple(A,B1,B2). % this also deduces bot if
                                % there are no knowledge atoms

% bot must hold in the counter model
:- not bot.

% show knowledge atoms
#show k/1.


%
% meta.lp modified
%

% as many models as k/1 atoms
model(1..M) :- M = { output(k(A),B) }.

conjunction(B,M) :- model(M), literal_tuple(B),
        hold(L,M) : literal_tuple(B, L), L > 0;
    not hold(L,M) : literal_tuple(B,-L), L > 0.

body(normal(B),M) :- model(M), rule(_,normal(B)), conjunction(B,M).
body(sum(B,G),M)  :- model(M), rule(_,sum(B,G)),
    #sum { W,L :     hold(L,M), weighted_literal_tuple(B, L,W), L > 0 ;
           W,L : not hold(L,M), weighted_literal_tuple(B,-L,W), L > 0 } >= G.

  hold(A,M) : atom_tuple(H,A)   :- rule(disjunction(H),B), body(B,M).
{ hold(A,M) : atom_tuple(H,A) } :- rule(     choice(H),B), body(B,M).

%#show.
%#show (T,M) : output(T,B), conjunction(B,M), not hide(T).

