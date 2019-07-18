using System;

namespace NumericIntegration
{   class Program
    {
        /*
        interface Callable<A, B>
        {
            B call(A val);
        }

        class Sine : Callable<double, double>
        {
            public double call(double val)
            {
                return Math.Sin(val);
            }
        }
        */

        static double CompositeSimpsons(Func<double, double> f, double a, double b, int n)
        {
            var step_size = (b - a) / n;
            var integral = 0.0;
            for(int k=0; k < n; k++)
            {
                var x_k0 = a + step_size * k;
                var x_k1 = a + step_size * (k + 1);
                var fac = f(x_k0) + 4 * f((x_k0 + x_k1) / 2) + f(x_k1);
                var step = step_size / 6 * fac;
                integral += step;
            }
            return integral;
        }

        static void Main(string[] args)
        {
            var integral = CompositeSimpsons(Math.Sin, 0, 2*Math.PI, 100000);
            Console.WriteLine($"{integral}");
        }
    }
}
