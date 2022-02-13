// go.go
// go(lang) implementation of numeric integration using Simpson's rule.
// To run this program type: go run go.go

package main

import (
	"fmt"
	"math"
)

func main() {
	integral := com_simpson(f, 0.0, 2.0*math.Pi, 100000)
	fmt.Print(integral)
}

// Test function: f(x) = sin(x)
func f(x float64) float64 {
	return math.Sin(x)
}

// Composite Simpson's rule.
// Integration of function f over interval [a,b] where n is
// the number of subintervals. Accuracy only depends on the
// number of subintervals.
func com_simpson(f func(float64) float64, a float64, b float64, n int) float64 {
	var x_k, x_k1 float64
	var h float64 = (b - a) / float64(n)
	var sum float64 = 0.0

	// Calculate integral value with composite simpson's rule
	for k := 1; k <= n; k++ {
		x_k = a + float64(k)*h
		x_k1 = a + (float64(k)-1.0)*h
		sum += h / 6 * (f(x_k1) + 4*f((x_k1+x_k)/2) + f(x_k))
	}

	return sum
}
