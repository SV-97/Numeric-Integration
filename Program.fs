// Learn more about F# at http://fsharp.org

open System

let simpson (f: double -> double) (a: double) (step: double) (k: int) : double = 
    let k_ = (double) k
    let xk = a + k_ * step
    let xk1 = a + (k_ + 1.0) * step
    step / 6.0 * (f xk + 4.0 * f((xk + xk1) / 2.0 ) + f xk1)
    
let compSimps (f: double -> double) a b n =
    let step = (b - a) / (double) n
    let simp = simpson f a step
    List.sumBy simp [0..n]
    
[<EntryPoint>]
let main argv =
    let integral = simpson sin 0.0 (2.0*Math.PI) 100000
    printf "%f" integral
    
    0 // return an integer exit code
