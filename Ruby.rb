def composite_simpsons(f, a, b, n)
    step_size = (b - a) / n
    integral = 0
    for k in 0...n
        x_k0 = a + k * step_size
        x_k1 = a + (k + 1) * step_size
        # step = step_size / 6 * (f(x_k0) + 4 * f((x_k0 + x_k1) / 2 ) + f(x_k1))
        step = step_size / 6 * (f.call(x_k0) + 4 * f.call((x_k0 + x_k1) / 2 ) + f.call(x_k1))
        integral += step
    end
    integral
end

integral = composite_simpsons(Proc.new {|x|Math.sin(x)}, 0, 2 * Math::PI, 100000)
puts integral