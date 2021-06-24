import casadi.*

%%% Model definitions
x1 = SX.sym('x1');
x2 = SX.sym('x2');

x = [x1;x2];

q1 = SX.sym('q1');
q2 = SX.sym('q2');

q = [q1;q2];


ode = [ q1^2; q2^2];

ode_struct = struct('x',x,'p',q,'ode',ode);
opts = struct('tf',1);
I = casadi.integrator('I','cvodes',ode_struct,opts);


%%%%% Input arguments
% parallel evaluation of the Jacobian for N = 3 initial values and parameters

% initial values and parameters

x0_1 = [1
       0];

x0_2 = [1
       0];

x0_3 = [1
       0];

q_1 = [1
      2];

q_2 = [3
      4];

q_3 = [5
      6];

x0 = [repmat(x0_1,1,4) repmat(x0_2,1,4) repmat(x0_3,1,4)];
q = [repmat(q_1,1,4) repmat(q_2,1,4) repmat(q_3,1,4)];

% directions for one Jacobian
fwd_x0 = [1 0 0 0;
          0 1 0 0];

fwd_p  = [0 0 1 0;
          0 0 0 1];

% directions for all three Jacobians
fwd_x0 = repmat(fwd_x0,1,3);
fwd_p  = repmat(fwd_p,1,3);

% full jacobian
I_fwd = I.factory('I_fwd',{'x0','p','fwd:x0','fwd:p'},{'fwd:xf'});
res_fwd = I_fwd('x0', x0, 'p', q, 'fwd_x0',fwd_x0, 'fwd_p', fwd_p);

jacobian_1 = res_fwd.fwd_xf(:, 1:4)
jacobian_2 = res_fwd.fwd_xf(:, 4+(1:4))
jacobian_3 = res_fwd.fwd_xf(:, 8+(1:4))

