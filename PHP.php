<?php

function composite_simpsons($f, $a, $b, $n) {
    $step_size = ($b - $a) / $n;
    $integral = 0;
    for ($k=1; $k <= $n; $k++) {
        $x_k0 = $a + $step_size * $k;
        $x_k1 = $a + $step_size  * ($k - 1);

        $fac = $f($x_k0) + $f($x_k1) + 4 * $f(($x_k0 + $x_k1) / 2 );
        $step = $fac * $step_size / 6;
        $integral += $step;
    }
    return $integral;
}

$integral = composite_simpsons(function ($x) {return sin($x);} , 0, 2 * pi(), 100000);
echo $integral."\n"

?>