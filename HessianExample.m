import casadi.*


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


%%%% Input arguments
x0 = [1 1];
q  = [2 3];
fwd = eye(4);
fwd_x0 = fwd(:,1:2);
fwd_p = fwd(:,3:4);
lambda = [ 1 1];



%%%%% full jacobian
I_fwd = I.factory('I_fwd',{'x0','p','fwd:x0','fwd:p'},{'fwd:xf'});
res_fwd = I_fwd('x0', x0, 'p', q, 'fwd_x0',fwd_x0', 'fwd_p', fwd_p');

display("Jacobian:")
res_fwd.fwd_xf

%%%% jacobian multilplied by lambda from the left 
    
I_adj = I.factory('I_adj', {'x0','p', 'adj:xf'}, {'xf','adj:x0', 'adj:p'});
res_adj = I_adj('x0', x0, 'p', q, 'adj_xf',lambda);

display("Jacobian with adjoint lambda:")
[ res_adj.adj_x0' res_adj.adj_p']

%%%%%5 hessian of lambda^t xf

I_foa = I_adj.factory('I_foa',{'x0','p','adj_xf','fwd:x0','fwd:p'},{'fwd:adj_x0','fwd:adj_p'});
res_foa = I_foa('x0', x0, 'p', q, 'adj_xf',lambda,'fwd_x0',fwd_x0','fwd_p',fwd_p');

display("Hessian")
[res_foa.fwd_adj_x0; res_foa.fwd_adj_p]

