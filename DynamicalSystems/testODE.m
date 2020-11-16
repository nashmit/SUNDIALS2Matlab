import casadi.*

x = SX.sym('x');

sys = struct;
sys.x = x;
sys.ode = x^2;