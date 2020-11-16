clear;
clc;

addpath( '../functions');
init()

import casadi.*

x = SX.sym('x'); z = SX.sym('z'); p = SX.sym('p');

dae = struct('x',x,'z',z,'p',p,'ode',z+p,'alg',z*cos(z)-x);


intg_opts = struct;
intg_opts.expand = true;

helper_opts = struct;
helper_opts.jit = true;
%helper_opts.compiler = 'shell';
helper_opts.jit_options.verbose = true;
intg_opts.common_options.final_options = helper_opts;
intg_opts.t0 = 0
intg_opts.tf = 0.4

F = integrator('F', 'idas', dae, intg_opts);

disp(F)

r = F('x0',0,'z0',0,'p',0.1);

disp(r.xf)



