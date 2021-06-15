import casadi.*

%states
x = SX.sym('x',2);

%parameters
a = SX.sym('a',1);
b = SX.sym('b',1);
c = SX.sym('c',1);
d = SX.sym('d',1);

%control
u = SX.sym('u',1);

sys = struct;

sys.x = x;
sys.p = [u;a;b;c;d];
%sys.u = u;

sys.ode = [ 
    a * x(1) - b * x(1) * x(2) - x(1) * u ; 
    c * x(1) * x(2) - d * x(2) - x(2) * u 
    ];
