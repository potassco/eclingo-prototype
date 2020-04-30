% generate knowledge atoms
k(hold(L2,1)) :- ktuple(A,L1,L2), hold(L1,1).

% generate k(level()) atoms
k(level(A,L)) :- level(A,L).

% just one model
model(1).

% ok is known
k(ok).

% display
#show.
#show T : output(T,B), conjunction(B,1).
