%
% Usage: clingo --output=reify --reify-sccs       FILES | clingo -Wno-atom-undefined - meta_main.lp ktuple.lp meta_many.lp metaD.lp [level.lp meta_faeel.lp] -project OPTIONS
%        clingo --output=reify --reify-sccs example1.lp | clingo -Wno-atom-undefined - meta_main.lp ktuple.lp meta_many.lp metaD.lp  level.lp meta_faeel.lp  -project 0
%
% Note: Without the files level.lp and faeel.lp
%       the encoding represents Gelfond91 world views, while with them
%       the encoding represents     Faeel world views
%

% guess knowledge atoms
{ k(A) } :- ktuple(A,_,_).

% add skip(1), skip(2) or skip(3) to delete some parts
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

% as many models as k/1 atoms
model(1..M) :- M = { output(k(A),B) }, not skip(3).

