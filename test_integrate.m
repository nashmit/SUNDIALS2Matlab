addpath('MatlabFunc');
addpath( './functions');

clear all;
clc

%time interval
tStart =0;
tFin = 50;
%init state
x0 = [1;1];

M = 2; % number of shooting intervals

%one time initialization/build/compile integrator
InitODE( 'lotka_volterraCasADi',tStart , tFin/( M ) );

% inp.sd -- initial value for differential states $x_0$
XX0 = repmat( [x0], 1, M );

%ODE parameters ( per ODE integration call )
p = [ 2/3;4/3;1;1];

%control ( just some dummy variable... used to build some dummy control
%vector )
u = [ 0 ];
%building a vecror of control parameters for all M intervals ( the ideea
%is that you can have different control paramiters for each shooting
%interval )
uu = repmat(u, 1, M);

inp.M = M;

%inp.sd -- initial value for differential states $x_0$
inp.sd = XX0;

%inp.q -- constant control for integration horizon
inp.q = uu;

%inp.p -- local parameters
inp.p = p;

%must be added by the user/extracted from ODE... etc
nx = 2;
nq = 1;
np = 5;

%size of state X
inp.nx = nx;

%number of control parameters
inp.nq = nq;

%number of parameters
inp.np = np;

% set the number of threads for the thread pool used by the integrator
% ( this can also be done in a distributed way too... I'm not quite
% sure... )
inp.threads = 1;

result = integrate(inp);
result_fx = result.xf;
