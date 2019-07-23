PI := 3.14159265358979311599796346854418516159057617187500

compositeSimpsons := method(f, a, b, n,
    step_size := (b - a) / n
    integral := 0
    for(k, 0, n, 
        x_k0 := a + step_size * k
        x_k1 := a + step_size  * (k + 1)

        step := step_size / 6 * (f call(x_k0) + 4 * f call((x_k0 + x_k1) / 2 ) + f call(x_k1))
        integral = integral + step))

compositeSimpsons(block(x, x sin), 0, PI, 100000) println