/* Numerical_Integration.cpp */
/* -------------------------------------------
	Created by Joshua Simon.
	Date: 09.07.2018
 ------------------------------------------- */
#include <iostream>
#include <cmath>
using namespace std;

/* Functions */

// Create some functions you want to integrate like this:
double g (double x) {
	// Example 1: g(x) = x^2
	return pow(x,2.0);
}

double h (double x) {
	// Example 2: h(x) = sin(x)
	return sin(x);
}

// Composite Simpson's rule
double com_simpson (double f(double), double a, double b, int n);

// Trapezoidal rule
double trapez (double f(double), double a, double b, int n);

/* Main */
int main (void) {
	
	double interval_a = 0.0;		// lower interval bound
	double interval_b = 4.0;		// upper interval bound
	int n = 100;					// number of subintervals
	
	// Call functions to calculate integral value
	// Example 1:
	double integral_g_1 = com_simpson(g, interval_a, interval_b, n);
	double integral_g_2 = trapez(g, interval_a, interval_b, n);
	
	// Example 2:
	double integral_h_1 = com_simpson(h, 0.00, 3.141592654/2.0, 400);
	double integral_h_2 = trapez(h, 0.00, 3.141592654/2.0, 100);
	
	
	// Output
	cout << "Integral of g(x) over [" << interval_a << "," << interval_b << "] " << endl;
	cout << "Simpson: " << integral_g_1 << endl;
	cout << "Trapez:  " << integral_g_2 << endl;
	cout << "Exact value is " << 1./3. * (4.*4.*4.) << " ." << endl << endl;
	
	cout << "Integral of h(x) over [0,pi/2] " << endl;
	cout << "Simpson: " << integral_h_1 << endl;
	cout << "Trapez:  " << integral_h_2 << endl;
	cout << "Exact value is " << -cos(3.141592654/2.) + cos(0.) << " ." << endl << endl;
	
	
	system("Pause");
}

// Composite Simpson's rule
double com_simpson (double f(double), double a, double b, int n) {
	
	// Integration of function f over interval [a,b] where n is
	// the number of subintervals. Accuracy only depends on the 
	// number of subintervals.
	double h, x_k, x_k1, simpson;
	double sum = 0.00;
	
	if(a > b)
	{
		cerr << "ERROR: Lower interval bound a has to be smaller than upper bound b." << endl;
		return 0;
	}
	
	// Step length h
	h = (b - a) / n;
	
	// Calculate integral value with composite simpson's rule
	for ( int k = 0; k <= n; k++)
	{
		x_k = a + k * h;
		x_k1 = a + (k+1) * h;
		
		simpson = h/6 * ( f(x_k) + 4* f((x_k + x_k1)/2) + f(x_k1));
		
		sum = sum + simpson;
	}
	
	return sum;
}

// Trapezoidal rule
double trapez (double f(double), double a, double b, int n) {
	
	// Integration of function f over interval [a,b] where n is
	// the number of subintervals. Accuracy only depends on the 
	// number of subintervals. The trapezoidal rule converges 
	// rapidly for periodic functions.
	double h;
	double sum = 0.00;
	
	if(a > b)
	{
		cerr << "ERROR: Lower interval bound a has to be smaller than upper bound b." << endl;
		return 0;
	}
	
	// Step length h
	h = (b - a) / n;
	
	// Calculate integral value with trapezoidal rule
	for (int k = 1; k <= n-1; k++)
	{
		sum = sum + f(a + k*h);
	}
	
	return h * (0.5 * f(a) + 0.5 * f(b) + sum);
}
