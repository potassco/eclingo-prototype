% L1 is the number of k(A) and L2 is the number of A (or x if A does not appear)
ktuple(A,L1,L2) :- output(k(A),B1), literal_tuple(B1,L1),
                   output(  A ,B2), literal_tuple(B2,L2).
ktuple(A,L1, x) :- output(k(A),B1), literal_tuple(B1,L1), not output(A,_).

% check errors
#show error(1,k(A)) : ktuple(A,L1,L2), 1 { L1<0; L2<0 }.
#show error(2,k(A)) : output(k(A),B1),               { literal_tuple(B1,L1) } != 1.
#show error(3,k(A)) : output(k(A),B1), output(A,B2), { literal_tuple(B2,L2) } != 1.

