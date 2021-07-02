function InitODEWSensititesAndHessian( example_name, t0, tf, shooting_intervals, nrThreads, integrator_name, verbose, print_stats )
% This function is used to initialize a dynamical system
% http://casadi.sourceforge.net/api/html/db/d3d/classcasadi_1_1Integrator.html
% input:
%   example_name                -> name of the file that defines the dynamical system
%   t0,tf                       -> initial and final time for the integrator
%                               -> default: [0,1]
%
%   shooting_intervals          -> number of shooting intervals
%                               -> default: 1
%
%   integrator_name             -> cvodes
%                               -> idas
%                               -> collocation
%                               -> oldcollocation
%                               -> rk 
%                               -> default: cvodes
%
% verbose                       -> Verbose evaluation – for debugging
%                               -> default: false
%
% print_stats                   -> Print out statistics after integration
%                               -> default: false

    global s2m;
    if nargin < 3
        t0 = 0;
        tf = 1;
    end
    if nargin < 4
        shooting_intervals = 1;
    end
    if nargin < 5
        nrThreads = 1;
    end
    if nargin < 6
        integrator_name = 'cvodes';
    end
    if nargin < 7
        verbose = false;
    end
    if nargin < 8
        print_stats = false;
    end
    
    addpath( './casadi' );
    import casadi.*
    
    addpath( './DynamicalSystems');
    
    run( example_name );

    intg_opts = struct;
    intg_opts.expand = true;

    helper_opts = struct;
    helper_opts.jit = true;
    %helper_opts.compiler = 'shell';
    helper_opts.jit_options.verbose = true;
    intg_opts.common_options.final_options = helper_opts;
    intg_opts.t0 = t0;
    intg_opts.tf = tf;
    intg_opts.verbose = verbose;
    intg_opts.print_stats = print_stats;
    intg_opts.max_multistep_order = 10;

    %intg = integrator('intg','cvodes',sys,intg_opts);
    intg = integrator('intg' ,integrator_name, sys, intg_opts );
    
    s2m.integrator = intg;
    
    %generate shooting_intervals shooting integration intervals
    multiple_shooting_simulation = intg.map(shooting_intervals,'thread',nrThreads);
    
    s2m.I_fwd_integrator_and_jacobian = multiple_shooting_simulation.factory('I_fwd_integrator_jacobian',{'x0','p','fwd:x0','fwd:p'},{'fwd:xf','xf'});
    
    %jacobian multilplied by lambda from the left 
    s2m.I_adj = multiple_shooting_simulation.factory('I_adj', {'x0','p', 'adj:xf'}, {'xf','adj:x0', 'adj:p'});
    
    %hessian of lambda^t xf
    s2m.I_foa = s2m.I_adj.factory('I_foa',{'x0','p','adj_xf','fwd:x0','fwd:p'},{'fwd:adj_x0','fwd:adj_p'});

    
end