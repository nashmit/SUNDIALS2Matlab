function outp = integrate(inp)

    global s2m;
    F = s2m.integrator;

    %disp(F);
    
    nrThreads = inp.threads;
    
    x0 = inp.sd; % initial values for each interval
    u = inp.q; % controls for each shooting interval ( M size )
    p = inp.p; % local parameters ( the parameters of the ODE ). this vector will be multiplied after by M times.
    
    M = inp.M; % number of intervals
    
    %generate M shooting integration intervals
    multiple_shooting_simulation = F.map(M,'thread',nrThreads);
    
    %repet parameters for each shooting interval
    parameters_all_intervals = repmat( p, 1, M );
    %concatenate control parameter with parameters_all_intervals
    parameters_and_control = [u; parameters_all_intervals];

    %trigger the integrator
    result = multiple_shooting_simulation( 'x0', x0, 'p', parameters_and_control, 'z0', [], 'rx0', [], 'rp', [], 'rz0', [] );
    
    outp.xf = result.xf;

end