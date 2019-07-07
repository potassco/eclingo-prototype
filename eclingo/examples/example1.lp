% initial situation
{ f(0); g(0) }.

% generate actions
{ a(1); b(1) } = 1.

% effects
goal :- a(1),     f(0).
goal :- a(1), not f(0).
goal :- b(1),     g(0).
goal :- b(1), not g(0).

% action occurrences are known
:- a(1), not k(a(1)).
:- b(1), not k(b(1)).

% goal is known
:- not k(goal).

%
% extra
%
{ k(a(1)); k(b(1)); k(goal) }.
#show a/1.
#show b/1.
#show goal/0.
#show k/1.


