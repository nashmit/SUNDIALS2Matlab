import casadi.*

x = SX.sym('x',2);
t = SX.sym('t',1);

sys = struct;
sys.x = x;
sys.t = t;

sys.ode = [ x(2); (2-2*t*x(2)-3*x(1))/(1+t^2) ];