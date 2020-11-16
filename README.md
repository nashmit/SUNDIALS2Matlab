# SUNDIALS2Matlab
practical numerical optimization Heidelberg ( Matlab integration of SUNDIALS )

> **_NOTE:_**  This is an initial description of the interface. I will extend the number of needed functions over time. But i guess the description below enables you to start the implementation. The names of the functions are not very precise; maybe you have a better idea...


## Dynamical System Description

$$
\dot{x}(t) = f(t, x(t), q, p)   \\
x(t_0)  =x_0
$$
- $t$ time
- $x$ differential states
- $q$ control( constant) 
- $p$ parameter


## Calling Convention for Matlab Functions

All functions are called with on input argument `inp` and return one output argument `outp`. So all function calls have the header `function outp = functionname(inp)`. Not all input attributes are always needed and not alle output attributes are always computed

The input has the following attributes:

- `inp.thoriz` -- integration horizon in the form [$t_0$ $t_f$]
- `inp.sd`  -- initial value for differential states $x_0$ 
- `inp.sa`  -- initial value for algebraic stats (not used right now)
- `inp.q`   -- constant control for integration horizon
- `inp.p`   -- local parameters
- `inp.sensdirs` -- sensitivity directions in form of matrix
- `inp.lambda` -- adjoint sensitivity direction

The output has the following attributes:

- `outp.x`  -- solution of ode at $t_f$
- `outp.G`  -- sensitivities with respect to $x_0$ and $q$  