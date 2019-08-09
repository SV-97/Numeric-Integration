// rustc -C opt-level=3 Rust.rs

fn composite_simpsons<F>(f: F, a: f64, b: f64, n: usize) -> f64
where
    F: (Fn(f64) -> f64),
{
    let step_size = (b - a) / n as f64;
    let mut integral = 0.0;
    for k in 1..n + 1 {
        let k = k as f64;
        let x_k0 = a + step_size * k;
        let x_k1 = a + step_size * (k - 1.0);

        let fac = f(x_k0) + f(x_k1) + 4.0 * f((x_k0 + x_k1) / 2.0);
        let step = step_size / 6.0 * fac;
        integral += step;
    }
    integral
}

fn main() {
    use std::f64;
    let integral = composite_simpsons(f64::sin, 0., 2. * f64::consts::PI, 100000);
    println!("{:e}", integral);
}
