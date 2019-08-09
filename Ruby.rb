def composite_simpsons(f, a, b, n)
    step_size = (b - a) / Float(n)
    integral = 0
    for k in 1..n
        x_k0 = a + k * step_size
        x_k1 = a + (k - 1) * step_size
        fact = f.call(x_k0) + f.call(x_k1) + 4 * f.call((x_k0 + x_k1) / 2 )
        step = step_size / 6 * fact
        integral += step
    end
    integral
end

integral = composite_simpsons(Proc.new {|x| Math.sin(x)}, 0, 2 * Math::PI, 100000)
# integral = composite_simpsons(Proc.new {|x| 3**(3 * x - 1)}, 1, 2, 3)
puts integral