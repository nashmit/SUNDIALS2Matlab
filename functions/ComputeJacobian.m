function outp = ComputeJacobian(inp)
    
    global s2m;
    F = s2m.integrator;

    %disp(F);
    
    nrThreads = inp.threads;
    
    x0 = inp.sd; % initial values for each interval
    u = inp.q; % controls for each integrator call ( NXM size )
    p = inp.p; % local parameters ( the parameters of the ODE ). this vector will be multiplied after by N*M times.
    
    M = inp.M; % number of intervals
    N = inp.N; % number of integrations steps per interval
    
    % preparing a fix-time size interval for integration by triggaring "N"
    % times the integrator in a cumulative way
    simulation_single_intervale = F.mapaccum(N); 
    % apply the predecessor step M times, for each interval, in a
    % independent way
    multiple_shooting_simulation = simulation_single_intervale.map(M,'thread',nrThreads);
    
    parameters_one_interval = [
        % I've considered that the parameters will not change for all
        % intervals N X M
        repmat(p,1,N)
        % I've considered that the control parameter is different for each
        % N X M intervals
        ];
    
    %repet parameters for each interval
    parameters_all_intervals = repmat( parameters_one_interval, 1, M );
    %concatenate the control parameter with parameters_all_intervals
    parameters_and_control = [u; parameters_all_intervals;];
    
    I_jac_x0 = multiple_shooting_simulation.factory('I_jac_x0', {'x0', 'p'}, ['jac:xf:x0']);
    I_jac_p = multiple_shooting_simulation.factory('I_jac_p', {'x0', 'p'}, ['jac:xf:p']);
    
    result_for_x0 = I_jac_x0('x0', x0, 'p', parameters_and_control);
    jac_xf_x0 = full( result_for_x0.jac_xf_x0 );
    
    result_for_p = I_jac_p('x0', x0, 'p', parameters_and_control);
    jac_xf_p = full( result_for_p.jac_xf_p );
    
    %this approach is not nice... and I'm pretty sure it's slow too... 
    %but I don't know better
    Gx = [];
    for index = 0 : inp.M - 1
        index1 = 1 + index * inp.N * inp.nx;
        index2 = 1 + index * inp.nx;
        
        Gx_aux = jac_xf_x0(index1 : index1 + inp.N *inp.nx -1, index2 : index2 + inp.nx -1);
        Gx = [Gx; Gx_aux];
    end
    
    Gp = [];
    for index = 0 : inp.M - 1
        index1 = 1 + index * inp.N * inp.nx;
        index2 = 1 + index * inp.np * inp.N;
        
        Gp_aux = jac_xf_p(index1 : index1 + inp.N *inp.nx -1, index2 : index2 + inp.np -1);
        Gp = [ Gp; Gp_aux];
    end
    G = [ Gx Gp ]; % Gx is wrt x0 of each interval/ Gp contains also the control parameters
    outp.G = G;
end