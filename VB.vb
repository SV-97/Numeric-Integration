Module Module1

	Public Function CompositeSimpsons(f As Func(Of Double, Double), a As Double, b As Double, n As Integer) As Double
		' Integration of function f over interval [a,b] where n Is
		' the number of subintervals. Accuracy only depends on the
		' number of subintervals.
		Dim h As Double, x_k As Double, x_k1 As Double, simpson As Double
		Dim sum As Double

		sum = 0.0

		' Step length h
		h = (b - a) / n

		' Calculate integral value with composite simpson's rule
		For k = 1 To n
			x_k = a + k * h
			x_k1 = a + (k - 1.0) * h
			simpson = h / 6 * (f(x_k1) + 4 * f((x_k1 + x_k) / 2) + f(x_k))
			sum += simpson
		Next k

		Return sum

	End Function

	Sub Main()
		Dim integral As Double

		integral = CompositeSimpsons(AddressOf Math.Sin, 0.0, Math.PI * 2.0, 100000)
		Console.WriteLine(integral)
		Console.ReadLine()
	End Sub

End Module
