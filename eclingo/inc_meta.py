#script(python)

#
# Usage: clingo-banane --output=reify --reify-sccs       FILES | clingo-banane -Wno-atom-undefined - inc_meta.py meta_main.lp ktuple.lp metaD.lp [level.lp meta_faeel.lp] -project OPTIONS
#        clingo-banane --output=reify --reify-sccs example1.lp | clingo-banane -Wno-atom-undefined - inc_meta.py meta_main.lp ktuple.lp metaD.lp  level.lp meta_faeel.lp  -project 0

# Note: Without the files level.lp and faeel.lp
#       the encoding represents Gelfond91 world views, while with them
#       the encoding represents     Faeel world views
#
# Note: Computes only one solution. To compute more, we have to add constraints
#       We need clingo-banane (or clingo-5.5) because we use a [free] external
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
                print("UNSATISFIABLE (NO WORLD VIEW)")
                return
            # if SAT and cost == 1: continue
        step += 1

#end.

#program base.

% fix knowledge atoms in the models
skip(1). % skip the rule in main.lp, this is defined in guess(m)

% check false knowledge atoms in the models
%  if k(A) is false then A is false in some model m > 0
:- ktuple(A,L1,L2), not k(A), not false_after(A,0).
#external false_after(A,0) : ktuple(A,L1,L2).
skip(2). % skip the rule in main.lp

% skip the generation of model/1 atoms from main.lp
skip(3).

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
:- ktuple(A,L1,L2), model(m), k(A), not hold(L1,m).
:- ktuple(A,L1,L2), model(m), not k(A), hold(L1,m).

% for checking false knowledge atoms
%   A is false after m-1 if it is false at m or it is false after m
false_after(A,m-1) :- ktuple(A,L1,L2), not hold(L2,m).
false_after(A,m-1) :- ktuple(A,L1,L2), false_after(A,m).
#external false_after(A,m) : ktuple(A,L1,L2). [free]

% minimize false_after(m) where m is the last model
#minimize{ 1 : false_after(A,m), not not_last(m) }.
#external not_last(m).
not_last(m-1).

