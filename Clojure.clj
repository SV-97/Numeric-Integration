;; time clojure Clojure.clj

(comment
  (defn a [x, y]
    (do
      (def x1 (+ x 5))
      (def y2 (+ y 5))
      (+ x1 y2))))

(defn sum [l] (reduce + l))

(defn simpson [f, a, step, k]
  (do
    (def xk (+ a (* k step)))
    (def xk1 (+ a (* step (- k 1))))
    (* (/ step 6) (+ (f xk) (f xk1) (* 4 (f (/ (+ xk xk1) 2)))))))

(defn compSimps [f, a, b, n]
  (do
    (def step (/ (- b a) n))
    (def simp (partial simpson f a step))
    (sum (map simp (range 1 (+ 1 n))))))

(println (compSimps #(Math/sin %) 0.0 (* 2 Math/PI) 100000))
