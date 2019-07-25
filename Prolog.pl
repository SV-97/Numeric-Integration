/* swipl
['Prolog'].
compSimpson(f, 0, 2*pi(), 100000, Integral).
*/

% test stuff
test(X, Y) :- Y is X + 10.
g(F, X, Y) :- call(F, X, Y). % simple higher order predicate

test2(A, X, Y) :- Y is A + X.

curried_t2(X, Y) :-
    call(test2(1), X, Y).

test3(X, Y) :-
    assert((subPred(Z1, Z2) :- call(test2(1), Z1, Z2))),
    call(subPred, X, Y).

% actual implementation

f(X, Y) :- Y is sin(X).

count(0, []).
count(Count, [_|Tail]) :- count(TailCount, Tail), Count is TailCount + 1.

sum(0, []).
sum(Total, [X|Xs]) :- sum(PartSum, Xs), Total is X + PartSum.

simpson(F, A, Step, K, P) :- 
    Xk0 is A + K * Step,
    Xk1 is A + (K + 1) * Step,
    call(F, Xk0, Fxk0), 
    call(F, Xk1, Fxk1), 
    call(F, (Xk0 + Xk1) / 2, Fxk01), 
    P is Step / 6 * (Fxk0 + 4 * Fxk01 + Fxk1).

map(_, [], []).
map(F, [A|As], [B|Bs]) :-
    call(F, A, B),
    map(F, As, Bs).

range(Stop, Stop, []).
range(Start, Stop, [Start | Starts]) :-
    NStart is Start + 1,
    range(NStart, Stop, Starts).

compSimpson(F, A, B, N, Integral) :-
    Step is (B - A) / N,
    assert((cF(X, Y) :- call(simpson, F, A, Step, X, Y))), % cF(x, y) = curried F
    range(0, N, Steps),
    map(cF, Steps, Partials),
    sum(Integral, Partials).
