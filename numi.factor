USING: kernel sequences io generalizations math math.ranges math.functions math.constants prettyprint ;
IN: numi

: parens ( f a step k -- val )
    2dup [ * ] [ 1  -  * ] 2bi* ! f a k*step (k+1)*step
    pick [ + ] 2bi@ ! f k*step+a (k+1)*step+a
    2dup + 2 / ! f xk xk1 (xk+xk1)/2 
    4 npick ! f x1 x2 x3
    tri@ 4 * + + nip ; inline ! val

: simpson ( k f a step -- val ) dup 6 / [ 4 npick parens nip ] dip * ; inline

: compSimps ( n f a b -- val )
    4dup swap ! n f a b n f b a
    - nip swap / nip ! n f a step
    [ simpson ] 3curry swap ! simp n
    1 swap [a,b] ! simp range
    swap [ map ] call( x x -- x ) sum ; inline ! val

: main ( -- )
    100000 [ sin ] 0 2 pi * compSimps . ;

MAIN: main
