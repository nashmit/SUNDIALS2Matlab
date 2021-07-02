addpath('MatlabFunc');
addpath( './functions');

clear all;
clc

%time interval
tStart =0;
tFin = 50;
%init state
x0 = [1;1];

%[N,~] = size(t)
N = 10 % nr. of integration steps in each interval from multiple shooting.
M = 1 % number of intervals 
InitODE( 'lotka_volterraCasADi',tStart , tFin/( N * M ) );

global s2m;
F = s2m.integrator;

disp(F);

simulation_single_intervale = F.mapaccum(N);
multiple_shooting_simulation = simulation_single_intervale.map(M,'thread',4);

%useful for multiple shooting as it triggers the integration for all 
%subintervals in parallel.
%sim = F.map(N);

% Calculate directional derivative, forward mode
% name, 
% {input: x0,p are the variable wrt which the computation is done } 
% {output: the variation of integration }
% the sensitivity is computed for each interval ( for each moment where the evaluation of the
% ODE is done ) in a cumulative way
%I_fwd = multiple_shooting_simulation.factory('I_fwd', {'x0', 'p', 'fwd:x0'}, {'fwd:xf'});
I_jac_x0 = multiple_shooting_simulation.factory('I_jac_x0', {'x0', 'p'}, ['jac:xf:x0']);
I_jac_p = multiple_shooting_simulation.factory('I_jac_p', {'x0', 'p'}, ['jac:xf:p']);


% x0 initial value
% 'p' for each integration interval.
% 'p' is the concatenation of the parameters and control. CasADi doesn't
% differentiate beteen them.
% fwd_x0: directional derivative

%F : (fwd_x0, fwd_p) -> (fwd_xf, fwd_qf), where
%
%fwd_xf := d(xf)/d(x0)*fwd_x0 + d(xf)/dp*fwd_p
%fwd_qf := d(qf)/d(x0)*fwd_x0 + d(qf)/dp*fwd_p
%
%So, fwd_p and fwd_x0 can of course be vectors.

XX0 = repmat( [x0], 1, M );

p = [ 2/3;4/3;1;1];
u = [ 0 ];
parameters = [
    repmat(p,1,N) ;
    repmat(u,1,N)
    ];
%parameters = parameters';

ppp = repmat( parameters, 1, M);

%res = I_fwd('x0', XX0, 'p', ppp, 'fwd_x0', [1;1]);
res = I_jac_x0('x0', XX0, 'p', ppp);
%fwd_xf = full(res.fwd_xf);
jac_xf_x0 = full(res.jac_xf_x0);

%fprintf('%50s: d(xf)/d(x0)=%s ', 'Forward sensitivities', ...
%    sprintf('%d ', fwd_xf) );
fprintf('%50s: jac_xf_x0=%s ', 'Jacobian sensitivities', ...
    sprintf('%d ', jac_xf_x0) );




%r = sim('x0', x0, 'p', repmat([2/3;4/3;1;1;0],1,N), 'z0', [], 'rx0', [], 'rp', [], 'rz0', [] );
r = multiple_shooting_simulation('x0', XX0, 'p', ppp, 'z0', [], 'rx0', [], 'rp', [], 'rz0', [] );



sol = full(r.xf);

time = linspace(tStart,tFin,N);
figure (4)
plot(time,sol(1,1:N),'--');
hold on
plot(time,sol(2,1:N),'--');
hold off
figure (5)
plot(sol(1,1:N),sol(2,1:N),'-');