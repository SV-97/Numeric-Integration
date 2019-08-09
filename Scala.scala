// scalac Scala.scala && scala ScalaSimpson

object ScalaSimpson {
     def simpson(f: Double => Double, a: Double, step: Double)(k: Int): Double = {
        val xk = a + k * step
        val xk1 = a + (k - 1) * step
        step / 6 * (f(xk) + f(xk1) + 4 * f((xk + xk1) / 2))
    }

    def compSimpson(f: Double => Double, a: Double, b: Double, n: Int): Double = {
        val step = (b - a) / n
        val simp = simpson(f, a, step)(_)
        (1 to n).map(simp).sum
    }

    def main(args: Array[String]): Unit = {
        val integral = compSimpson(scala.math.sin(_), 0, 2 * scala.math.Pi, 100000)
        println(integral)
    }
}
