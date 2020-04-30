% define ok
ok(A) :- ktuple(A,L1,L2), not k(hold(L2,1)).
ok(A) :- ktuple(A,L1,L2), hold(L1).
ok :- ok(A) : ktuple(A,L1,L2). % this also deduces bot if
#show ok/0.
