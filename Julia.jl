# Numerical_Integration.jl
# Date: 28.06.2019. Created by Joshua Simon. 

# Define some functions you want to integrate

function com_simpson(f, a, b, n)
    # Composite Simpson's rule
    # Integration of function f over interval [a,b] where n is
    # the number of subintervals. Accuracy only depends on the 
    # number of subintervals.
    
    sum = 0

    if(a > b)
        println("ERROR: Lower interval bound a has to be smaller than upper bound b.")
        return 0
    end

    # Step length h
    h = (b - a) / n

    # Calculate integral value with composite simpson's rule
    for k = 1:n

        x_k = a + k * h
		x_k1 = a + (k - 1) * h
		
		simpson = h/6 * ( f(x_k1) + f(x_k) + 4* f((x_k1 + x_k)/2) )
		
        sum += simpson
    end

    return sum

end

integral_k_1 = com_simpson(sin, 0.0, pi*2.0, 100000)

println(integral_k_1)