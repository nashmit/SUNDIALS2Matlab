function outp = integrateWSensitiviesAndHessian(inp)

    global s2m;
    F = s2m.integrator;

    %disp(F);
    
    %nrThreads = inp.threads;
    
    x0 = inp.sd; % initial values for each interval
    u = inp.q; % controls for each shooting interval ( M size )
    p = inp.p; % local parameters ( the parameters of the ODE ). this vector will be multiplied after by M times.
    
    M = inp.M; % number of intervals
    
    %number of sensitivity directions
    nr_sensdirs = inp.nr_sensdirs;
    
    fwd_x0 = inp.fwd_x0;
    fwd_p = inp.fwd_p;
    
    lambda = inp.lambda;
    
    %generate M shooting integration intervals
    %multiple_shooting_simulation = F.map(M,'thread',nrThreads);
    
    %repet parameters for each shooting interval
    parameters_all_intervals = repmat( p, 1, M );
    %concatenate control parameter with parameters_all_intervals
    parameters_and_control = [u; parameters_all_intervals];
    
    %each column of the transpose matrix must be duplicated M
    %times.
    fwd_x0 = kron(fwd_x0', ones(1,M));
    fwd_p = kron(fwd_p', ones(1,M));
    
    %I_fwd_integrator_and_jacobian = multiple_shooting_simulation.factory('I_fwd_integrator_jacobian',{'x0','p','fwd:x0','fwd:p'},{'fwd:xf','xf'});
    I_fwd_integrator_and_jacobian = s2m.I_fwd_integrator_and_jacobian;
    result_for_fwd = I_fwd_integrator_and_jacobian('x0', x0, 'p', parameters_and_control, 'fwd_x0',fwd_x0, 'fwd_p', fwd_p);
    
    %result_for_fwd.fwd_xf
    %result_for_fwd.xf
    
    result_fwd_xf = full(result_for_fwd.fwd_xf);
    result_xf = full(result_for_fwd.xf);
    
    %dummy initialization
    result_fwd_xf_final = [1];
    result_xf_final = [1];
    
    for index=1:M
        aux = result_fwd_xf(:, index:M:(inp.nx+inp.np)*M*nr_sensdirs);
        if index==1
            result_fwd_xf_final = aux;
        else
            result_fwd_xf_final = [result_fwd_xf_final; aux];
        end
        aux = result_xf(:, (inp.nx+inp.np)*index );
        if index==1
            result_xf_final = aux;
        else
            result_xf_final = [result_xf_final aux];
        end
    end
    
    outp.result_fwd_xf = result_fwd_xf_final;
    outp.result_xf = result_xf_final;
    
    lambda = repmat( lambda, 1, M );
    
    %%%% jacobian multilplied by lambda from the left 
    I_adj = s2m.I_adj;
    %res_adj = I_adj('x0', x0, 'p', parameters_and_control, 'adj_xf',lambda);

    %display("Jacobian with adjoint lambda:")
    %[ res_adj.adj_x0' res_adj.adj_p']
    
    %%%%%5 hessian of lambda^t xf
    I_foa = s2m.I_foa;
    res_foa = I_foa('x0', x0, 'p', parameters_and_control, 'adj_xf',lambda,'fwd_x0',fwd_x0,'fwd_p',fwd_p);
    
    %display("Hessian")
    %[res_foa.fwd_adj_x0; res_foa.fwd_adj_p]
    
    result_fwd_adj_x0_fina = full(res_foa.fwd_adj_x0);
    result_fwd_adj_p_fina = full(res_foa.fwd_adj_p);
    
    outp.fwd_adj_x0 = result_fwd_adj_x0_fina;
    outp.fwd_adj_p = result_fwd_adj_p_fina;
    
    
end