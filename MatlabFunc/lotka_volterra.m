function dxdt = lotka_volterra( t, x, parameters_and_control)
    
    dxdt = [0;0];
    
    u = parameters_and_control(1);
    a = parameters_and_control(2); 
    b = parameters_and_control(3); 
    c = parameters_and_control(4); 
    d = parameters_and_control(5);
    
    %a =0.4; b = 0.4; c = 0.02; d = 2.0; u = 0;
    
    dxdt(1) = a * x(1) - b * x(1) * x(2) - x(1) * u;
    dxdt(2) = c * x(1) * x(2) - d * x(2) - x(2) * u;
end

