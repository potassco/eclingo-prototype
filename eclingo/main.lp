%
% Usage: clingo --output=reify --reify-sccs       FILES |  clingo -Wno-atom-undefined - main.lp many.lp metaD.lp [faeel.lp] -project OPTIONS
%        clingo --output=reify --reify-sccs example1.lp |  clingo -Wno-atom-undefined - main.lp many.lp metaD.lp  faeel.lp  -project 0
%
% Without the file faeel.lp the encoding represents Gelfond91 world views,
%       while with faeel.lp the encoding represents     Faeel world views
%

% L1 is the number of k(A) and L2 is the number of A (or x if A does not appear)
ktuple(A,L1,L2) :- output(k(A),B1), literal_tuple(B1,L1),
                   output(  A ,B2), literal_tuple(B2,L2).
ktuple(A,L1, x) :- output(k(A),B1), literal_tuple(B1,L1), not output(A,_).

% check errors
#show error(1,k(A)) : ktuple(A,L1,L2), 1 { L1<0; L2<0 }.
#show error(2,k(A)) : output(k(A),B1),               { literal_tuple(B1,L1) } != 1.
#show error(3,k(A)) : output(k(A),B1), output(A,B2), { literal_tuple(B2,L2) } != 1.

% guess knowledge atoms
{ k(A) } :- ktuple(A,_,_).

% add skip(1) or skip(2) to delete the next constraints
#defined skip/1.

% fix knowledge atoms in the models
:- ktuple(A,L1,L2), model(M), k(A), not hold(L1,M), not skip(1).
:- ktuple(A,L1,L2), model(M), not k(A), hold(L1,M), not skip(1).

% check false knowledge atoms in the models
:- ktuple(A,L1,L2), not k(A), hold(L2,M) : model(M); not skip(2).

% fix knowledge atoms in the counter model
bot :- ktuple(A,L1,L2),     k(A), fail(atom(L1)).
bot :- ktuple(A,L1,L2), not k(A), true(atom(L1)).

% check true knowledge atoms in the counter model
ok(A) :- ktuple(A,L1,L2), not k(A).
ok(A) :- ktuple(A,L1,L2), true(atom(L2)),
         hold(L1) : faeel. % REPLACED L2 by L1
bot :- ok(A) : ktuple(A,L1,L2). % this also deduces bot if
                                % there are no knowledge atoms

% bot must hold in the counter model
:- not bot.

% show knowledge atoms
#show k/1.

