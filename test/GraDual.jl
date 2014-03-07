using ForwardDiff
using Base.Test

### Testing functions f:R^n->R

# Testing addition, subtraction, scalar multiplication, multiplication and integer powers

f(x, y, z) = x^6-y^5+z^2+x^4*y*z-3*x*y^3*z^2+2*x^2*y^3-4*y^2*z+y*z^2-2*x*y*z

dfdx(x, y, z) = 6*x^5+4*x^3*y*z-3*y^3*z^2+4*x*y^3-2*y*z
dfdy(x, y, z) = -5*y^4+x^4*z-9*x*y^2*z^2+6*x^2*y^2-8*y*z+z^2-2*x*z
dfdz(x, y, z) = 2*z+x^4*y-6*x*y^3*z-4*y^2+2*y*z-2*x*y
gradf(x, y, z) = [dfdx(x, y, z), dfdy(x, y, z), dfdz(x, y, z)]

args = [2.3, -1.5, -4.]
output = f(GraDual(args)...)

@test_approx_eq value(output) f(args...)
@test_approx_eq grad(output) gradf(args...)

# Testing the API

g = forwarddiff_jacobian(f, Float64, fadtype=:typed)
output = g(args)
@test_approx_eq output gradf(args...)

# Testing division

f(x, y, z) = x^5*z/y^4-1/z

dfdx(x, y, z) = 5*z*x^4/y^4
dfdy(x, y, z) = -4*x^5*z/y^5
dfdz(x, y, z) = x^5/y^4+1/z^2
gradf(x, y, z) = [dfdx(x, y, z), dfdy(x, y, z), dfdz(x, y, z)]

args = [2., 5., -1.]
output = f(GraDual(args)...)

@test_approx_eq value(output) f(args...)
@test_approx_eq grad(output) gradf(args...)

# Testing square roots, qubic roots and rational powers

f(x, y, z) = z^4*sqrt(x)/cbrt(y)+x^(-5//3)

dfdx(x, y, z) = z^4/(2*sqrt(x)*cbrt(y))-5//3*x^(-8//3)
dfdy(x, y, z) = -z^4*sqrt(x)/(3*y^(4//3))
dfdz(x, y, z) = 4*z^3*sqrt(x)/cbrt(y)
gradf(x, y, z) = [dfdx(x, y, z), dfdy(x, y, z), dfdz(x, y, z)]

args = [0.75, 2.5, -1.25]
output = f(GraDual(args)...)

@test_approx_eq value(output) f(args...)
@test_approx_eq grad(output) gradf(args...)