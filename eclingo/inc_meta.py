#script(python)

#
# Usage: clingo-banane --output=reify --reify-sccs       FILES |  clingo-banane -Wno-atom-undefined - inc_meta.py metaD.lp 0 OPTIONS
#        clingo-banane --output=reify --reify-sccs example1.lp |  clingo-banane -Wno-atom-undefined - inc_meta.py metaD.lp 0
# Note: Computes only one solution. To compute more, we have to add constraints
#       We need clingo-banane because we use a [free] external
#

K_NAME = "k"
K_ARITY = 1

def main(control):

    # ground base
    control.ground([("base", [])])

    # gather number of ks
    ks = 0
    for atom in control.symbolic_atoms.by_signature(K_NAME, K_ARITY):
        ks += 1

    # loop
    step = 1
    while True:
        control.ground([("guess", [step])])
        with control.solve(yield_=True) as handle:
            last = None
            for m in handle:
                last = m
            # if SAT and cost == 0: return SAT
            if last is not None and last.cost == [0]:
                print("SATISFIABLE")
                return
            # if UNSAT or last step: return UNSAT
            if last is None or step == ks:
                return
            # if SAT and cost == 1: continue
        step += 1

#end.

#program base.

% the conjunction of k(A) is B1 and the one of A is B2
ktuple(A,B1,B2) :- output(k(A),B1),     output(A,B2).
ktuple(A,B1,xx) :- output(k(A),B1), not output(A, _).

% choose knowledge atoms
{ k(A) } :- ktuple(A,B1,B2).

% check false knowledge atoms
%  if k(A) is false then A is false in some model m > 0
:- ktuple(A,B1,B2), not k(A), not false_after(A,0).
#external false_after(A,0) : ktuple(A,B1,B2).

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
%#show false_after/2.

#program guess(m).

%
% meta.lp modified
%

% m is a model
model(m).

conjunction(B,m) :- model(m), literal_tuple(B),
        hold(L,m) : literal_tuple(B, L), L > 0;
    not hold(L,m) : literal_tuple(B,-L), L > 0.

body(normal(B),m) :- model(m), rule(_,normal(B)), conjunction(B,m).
body(sum(B,G),m)  :- model(m), rule(_,sum(B,G)),
    #sum { W,L :     hold(L,m), weighted_literal_tuple(B, L,W), L > 0 ;
           W,L : not hold(L,m), weighted_literal_tuple(B,-L,W), L > 0 } >= G.

  hold(A,m) : atom_tuple(H,A)   :- rule(disjunction(H),B), body(B,m).
{ hold(A,m) : atom_tuple(H,A) } :- rule(     choice(H),B), body(B,m).

%#show.
%#show (T,M) : output(T,B), conjunction(B,M), not hide(T).

% fix knowledge atoms in the model
:- ktuple(A,B1,B2), model(m), k(A), not conjunction(B1,m).
:- ktuple(A,B1,B2), model(m), not k(A), conjunction(B1,m).

% for checking false knowledge atoms
%   A is false after m-1 if it is false at m or it is false after m
false_after(A,m-1) :- ktuple(A,B1,B2), not conjunction(B2,m).
false_after(A,m-1) :- ktuple(A,B1,B2), false_after(A,m).
#external false_after(A,m) : ktuple(A,B1,B2). [free]

% minimize false_after(m) where m is the last model
#minimize{ 1 : false_after(A,m), not not_last(m) }.
#external not_last(m).
not_last(m-1).

