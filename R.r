# Numerical_Integration.r
# Date: 28.06.2019. Created by Joshua Simon. 

# Create some functions you want to integrate

f <- function(x) {
    return(sin(x))
}

com_simpson <- function(f, a, b, n) {
    # Composite Simpson's rule
    # Integration of function f over interval [a,b] where n is
	# the number of subintervals. Accuracy only depends on the 
	# number of subintervals.

    sum <- 0
    
    # Step length h
    h <- (b - a) / n

    # Calculate integral value with composite simpson's rule
    for (k in 1:n) {
        x_k <- a + k * h
		x_k1 <- a + (k-1) * h
        
		simpson <- h/6 * ( f(x_k1) + 4* f((x_k1 + x_k)/2) + f(x_k) )
		
        sum <- sum + simpson
    }
    
    return(sum)
}

integral <- com_simpson(f, 0.0, 2.0 * 3.141592654, 100000)

message(integral)
