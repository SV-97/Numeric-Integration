-- ghc -O Haskell.hs

{- f -> a -> b -> n -> I
Numerically integrate a function f from a to b
with segmentation into n parts to produce a value I
-}
compSimps :: (Double -> Double) -> Double -> Double -> Integer -> Double
compSimps f a b n = sum $ map simp [1..n]
    where
        simp = simpson f a step
        step = (b - a) / fromIntegral n

-- Compute one step k of a simpson integral
simpson :: (Double -> Double) -> Double -> Double -> Integer -> Double
simpson f a step k = step / 6 * (f xk + f xk1 + 4 * f((xk + xk1) / 2 ))
        where
            xk = a + k_ * step
            xk1 = a + (k_ - 1) * step
            k_ = fromIntegral k


main = do
    putStrLn $ show $ compSimps sin 0 (2*pi) 100000