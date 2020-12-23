% ODE: ( 1 + t^2 ) * dotdot( w ) + 2 * t * dot(w) + 3 * w = 2

%this test is not completely implemented!!!

addpath('MatlabFunc');
addpath( './functions');

clear all
clc



tspan=[0 5];
x0=[0; 1];
[t,x]=ode23(@diff_secondorder, tspan, x0);
figure (1)
plot(t,x);
legend('x1','x2');

tspan=[0 5];
x0=[0; 1];
[t,x]=ode23(@diff_secondorder, tspan, x0);
figure (2)
plot(t, x(:,2));