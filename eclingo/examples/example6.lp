#const n=1.
{ a(1..n) }.
b(X) :-   a(X) . c(X) :- not a(X), X=1..n.
c(X) :- k(b(X)). b(X) :-   k(c(X)).
{ k(b(1..n)) }. { k(c(1..n)) }.
:- not k(b(X)), X=1..n.
:- not k(c(X)), X=1..n.
