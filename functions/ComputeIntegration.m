function outp = ComputeIntegration(inp)

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
    %concatenate control parameter with parameters_all_intervals
    parameters_and_control = [u; parameters_all_intervals];
    
    %trigger the integrator
    result = multiple_shooting_simulation( 'x0', x0, 'p', parameters_and_control, 'z0', [], 'rx0', [], 'rp', [], 'rz0', [] );
    
    outp.xf = result.xf;
end