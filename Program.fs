open System

let simpson (f: double -> double) (a: double) (step: double) (k: int) : double = 
    let k_ = (double) k
    let xk = a + k_ * step
    let xk1 = a + (k_ - 1.0) * step
    step / 6.0 * (f xk + f xk1 + 4.0 * f((xk + xk1) / 2.0 ))
    
let compSimps (f: double -> double) a b n =
    let step = (b - a) / (double) n
    let simp = simpson f a step
    List.sumBy simp [1..n]
    
[<EntryPoint>]
let main argv =
    let integral = simpson sin 0.0 (2.0*Math.PI) 100000
    printf "%f" integral
    
    0 // return an integer exit code
