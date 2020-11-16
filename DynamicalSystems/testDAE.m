import casadi.*

x = SX.sym('x'); z = SX.sym('z'); p = SX.sym('p');

dae = struct('x',x,'z',z,'p',p,'ode',z+p,'alg',z*cos(z)-x);
