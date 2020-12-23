%van der Pol Equation, mu = 1000
import casadi.*

x = SX.sym('x',2);
mu = 1000;
sys = struct;
sys.x = x;
sys.ode = [ x(2); mu*(1-x(1)^2)*x(2)-x(1) ];



