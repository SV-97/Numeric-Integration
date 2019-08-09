# python Python.py

from math import sin, pi
# from numba import njit, jit

#@jit
def composite_simpsons(f, a, b, n):
    step_size = (b - a) / n
    integral = 0
    for k in range(1, n + 1):
        x_k0 = a + step_size * k
        x_k1 = a + step_size  * (k - 1)

        step = step_size / 6 * (f(x_k0) + f(x_k1) + 4 * f((x_k0 + x_k1) / 2 ))
        integral += step
    return integral


integral_of_function = composite_simpsons(sin, 0, 2*pi, 100000)
print(f"{integral_of_function}")