function xdot=Pendulum(t,x)
% Pendulum ODE derivative evaluation
xdot(1,1) = x(2,1);
xdot(2,1) = -0.1/(1*0.5)*x(2,1) -9.81/0.5*sin(x(1,1));
end
