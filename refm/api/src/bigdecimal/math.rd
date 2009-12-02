#@since 1.8.1

Provides mathematical functions.

Contents:
  sqrt(x, prec)
  sin (x, prec)
  cos (x, prec)
  atan(x, prec)  Note: |x|<1, x=0.9999 may not converge.
  exp (x, prec)
  log (x, prec)
  PI  (prec)
  E   (prec) == exp(1.0,prec)

where:
  x    ... BigDecimal number to be computed.
           |x| must be small enough to get convergence.
  prec ... Number of digits to be obtained.

Example:

  require "bigdecimal"
  require "bigdecimal/math"

  include BigMath

  a = BigDecimal((PI(100)/2).to_s)
  puts sin(a,100) # -> 0.10000000000000000000......E1

= module BigMath

== Instance Methods

--- sqrt(x, prec)

Computes the square root of x to the specified number of digits of 
precision.

  BigDecimal.new('2').sqrt(16).to_s 
   -> "0.14142135623730950488016887242096975E1"

--- sin(x, prec)

Computes the sine of x to the specified number of digits of precision.

If x is infinite or NaN, returns NaN.

--- cos(x, prec)

Computes the cosine of x to the specified number of digits of precision.

If x is infinite or NaN, returns NaN.

--- atan(x, prec)

Computes the arctangent of x to the specified number of digits of precision.

If x is infinite or NaN, returns NaN.
Raises an argument error if x > 1.

--- exp(x, prec)

Computes the value of e (the base of natural logarithms) raised to the 
power of x, to the specified number of digits of precision.

If x is infinite or NaN, returns NaN.

  BigMath::exp(BigDecimal.new('1'), 10).to_s
  -> "0.271828182845904523536028752390026306410273E1"

--- log(x, prec)

Computes the natural logarithm of x to the specified number of digits 
of precision.

Returns x if x is infinite or NaN.

--- PI(prec)

Computes the value of pi to the specified number of digits of precision.

--- E(prec)

Computes e (the base of natural logarithms) to the specified number of
digits of precision.

#@end
