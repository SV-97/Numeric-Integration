% erlc numi.erl && time escript numi.beam

-module(numi).

-export([compSimps/4, main/1]).

simpson(F, A, Step, K) ->
    Xk = A + K * Step,
    Xk1 = A + (K - 1) * Step,
    Step / 6 * (F(Xk) + F(Xk1) + 4 * F((Xk + Xk1) / 2)).

compSimps(F, A, B, N) ->
    Step = (B - A) / N,
    lists:sum(lists:map(fun (K) -> simpson(F, A, Step, K)
			end,
			lists:seq(1, N))).

main(_) ->
    io:write(compSimps(fun (X) -> math:sin(X) end, 0,
		       2 * math:pi(), 100000)).
