/* Numerical_Integration.cpp */
/* -------------------------------------------
	Created by Joshua Simon.
	Date: 09.07.2018
 ------------------------------------------- */
#include <iostream>
#include <cmath>
using namespace std;
#define PI acos(-1.0)

double k(double x) {
	// Example 3: k(x) = 3^(3*x-1)
	return pow(3, 3 * x - 1);
}

// Composite Simpson's rule
double com_simpson (double f(double), double a, double b, int n);

/* Main */
int main (void) {

	double integral_k_1 = com_simpson(sin, 0.0, 2.0 * PI, 100000);

	cout << integral_k_1 << endl;

}

// Composite Simpson's rule
double com_simpson(double f(double), double a, double b, int n) {

	// Integration of function f over interval [a,b] where n is
	// the number of subintervals. Accuracy only depends on the
	// number of subintervals.
	double h, x_k, x_k1, simpson;
	double sum = 0.0;

	if (a > b)
	{
		cerr << "ERROR: Lower interval bound a has to be smaller than upper bound b." << endl;
		return 0;
	}

	// Step length h
	h = (b - a) / n;

	// Calculate integral value with composite simpson's rule
	for (int k = 1; k <= n; k++)
	{
		x_k = a + k * h;
		x_k1 = a + (k - 1.0) * h;

		simpson = h / 6 * (f(x_k1) + 4 * f((x_k1 + x_k) / 2) + f(x_k));

		sum = sum + simpson;
	}

	return sum;
}
