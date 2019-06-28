// javac Main.java && java Main

public class Main
{
    public static void main(String[] args)
    {
        Main main = new Main();
        main.run();
    }

    public Main() {}
    public void run() {
        Sin sin = new Sin();
        double integral = composite_simpsons(sin, 0, 2 * Math.PI, 100000);
        System.out.println(String.valueOf(integral));
    }

    private double composite_simpsons(Method f, double a, double b, int n)
    {
        double step_size = (b - a) / n;
        double integral = 0;
        for (int k=0; k < n; k++) {
            double x_k0 = a + step_size * k;
            double x_k1 = a + step_size * (k + 1);

            double fac = f.run(x_k0) + 4 * f.run((x_k0 + x_k1) / 2 ) + f.run(x_k1);
            double step = fac * step_size / 6;
            integral += step;
        }
        return integral;
    }

    private abstract class Method {
        public abstract double run(double x);
    }

    private class Sin extends Method {
        public Sin() {}

        public double run(double x)
        {
            return Math.sin(x);
        }
    }
}