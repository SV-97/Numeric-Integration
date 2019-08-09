// gcc -O3 C.c -lm

#include <math.h>
#include <stdio.h>

#define PI acos(-1.0)

// Numerically integrate a function f from a to b in n steps
double composite_simpson(double (*f)(double), double a, double b, int n) {
    double step_size = (b - a) / n;
    double integral = 0;
    for (int k = 1; k <= n; k++) {
        double x_k0 = a + step_size * k;
        double x_k1 = a + step_size * (k - 1);

        double fac = f(x_k0) + f(x_k1) + 4 * f((x_k0 + x_k1) / 2 );
        double step = step_size / 6 * fac;
        integral += step;
    }
    return integral;
}

int main() {
    double (*f)(double) = &sin;
    double integral = composite_simpson(f, 0.0, 2.0 * PI, 100000);
    printf("%e\n", integral);
    return 0;
}