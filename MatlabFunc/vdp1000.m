function dy = vdp1000(t,y)
mu = 1000;
%The van der Pol Equation, μ = 1000 (Stiff)
dy = [y(2); mu*(1-y(1)^2)*y(2)-y(1)];
end