dom(1..100).

9 { a(X) : dom(X) }.

{ k(a(X)) : dom(X) }.

:- k(_), x, y.

:- not x,     y.
:-     x, not y.
:- not x, not y.
{ x; y }.

%*
#project k/1.
#show k/1.
#show a/1.
*%
