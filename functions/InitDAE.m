function initODE( example_name, t0, tf  )
% This function is used to initialize a dynamical system
% input:
%   example_name    -> name of the file that defines the dynamical system
%   t0,tf           -> initial and final time for the integrator
%                   -> if no values are given interval [0,1] is used

    global s2m;
    
    if nargin < 3
        t0 = 0;
        tf = 1;
    end
    
    addpath( './casadi' );
    import casadi.*
    
    addpath( './DynamicalSystems' );
    
    run( example_name );


    intg_opts = struct;
    intg_opts.expand = true;

    helper_opts = struct;
    helper_opts.jit = true;
    %helper_opts.compiler = 'shell';
    helper_opts.jit_options.verbose = true;
    intg_opts.common_options.final_options = helper_opts;
    intg_opts.t0 = t0
    intg_opts.tf = tf
    
    s2m.integrator = integrator('intg', 'idas', dae, intg_opts);
    
end