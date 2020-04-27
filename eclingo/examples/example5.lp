#const n=10.
{ a(1..n) }.
b :-     a(X).
b :- not a(_), k(b).
{ k(b) }.
:- not k(b).
