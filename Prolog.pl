/* swipl
['Prolog'].
compSimpson(f, 0, 2*pi(), 100000, Integral).
*/

% test stuff
% Just as a future reference, Lambdas: https://www.swi-prolog.org/pldoc/man?section=yall
test(X, Y) :- Y is X + 10.
g(F, X, Y) :- call(F, X, Y). % simple higher order predicate

test2(A, X, Y) :- Y is A + X.

curried_t2(X, Y) :-
    call(test2(1), X, Y).

test3(X, Y) :-
    assert((subPred(Z1, Z2) :- call(test2(1), Z1, Z2))),
    call(subPred, X, Y).

count([], 0).
count([_|Tail], Count) :- count(Tail, TailCount), Count is TailCount + 1.

% actual implementation

f(X, Y) :- Y is sin(X).

sum([], 0).
sum([X|Xs], Total) :- sum(Xs, PartSum), Total is X + PartSum.

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
 
% alternative range
% range(Start, Stop, List) :- findall(X, between(Start, Stop, X), List).
% may have better memory footprint
range(Start, Stop, Range) :-
    Start < Stop,
    insecureRange(Start, Stop, Range).

insecureRange(Stop, Stop, []).
insecureRange(Start, Stop, [Start | Starts]) :-
    NStart is Start + 1,
    insecureRange(NStart, Stop, Starts).

compSimpson(F, A, B, N, Integral) :-
    Step is (B - A) / N,
    range(0, N, Steps),
    map(simpson(F, A, Step), Steps, Partials),
    sum(Partials, Integral).

compSimpsonBuiltIns(F, A, B, N, Integral) :-
    Step is (B - A) / N,
    range(0, N, Steps),
    maplist(simpson(F, A, Step), Steps, Partials),
    sum_list(Partials, Integral).

% Make it executeable via command line: swipl Prolog.pl
exec(Integral) :- write("Handrolled: "), once(compSimpson(f, 0, 2, 100000, Integral)).
exec(Integral) :- write("Built-ins:  "), once(compSimpsonBuiltIns(f, 0, 2, 100000, Integral)).

:- forall(exec(X), (write(X), nl)),
    halt.
