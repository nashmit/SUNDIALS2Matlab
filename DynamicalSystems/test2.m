addpath( '../functions');
init()

import casadi.*

x = SX.sym('x');


sys = struct;
sys.x = x;
sys.ode = x^2;

intg_opts = struct;
intg_opts.expand = true;

helper_opts = struct;
helper_opts.jit = true;
%helper_opts.compiler = 'shell';
helper_opts.jit_options.verbose = true;
intg_opts.common_options.final_options = helper_opts;
intg_opts.t0=0;
intg_opts.tf=0.5;

intg = integrator('intg','cvodes',sys,intg_opts);

r = intg('x0',-0.1);
disp(r);
disp(r.xf);

