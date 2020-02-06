(optimize-level 2)
(let ()
    (define pi 3.14159)

    (define simpson
        (lambda (f a step k)
            (let
                ([xk (+ a (* k step))]
                [xk1 (+ a (* step (- k 1)))])
                (* (/ step 6) (+ (f xk) (f xk1) (* 4 (f (/ (+ xk xk1) 2))))))))

    (define sum (lambda (lst) (fold-left + 0 lst)))

    (define compSimps
        (lambda (f a b n)
        (letrec
            ([step (/ (- b a) n)]
            [simp (lambda (k) (simpson f a step k))])
            (sum (map simp (cdr (iota (+ n 1))))))))

    (display (compSimps sin 0.0 (* 2 pi) 100000))
    (exit))
    