%Pendulum
import casadi.*

x = SX.sym('x',2);

sys = struct;
sys.x = x;
sys.ode = [ x(2,1) ; -0.1/(1*0.5)*x(2,1)-9.81/0.5*sin(x(1,1)) ];