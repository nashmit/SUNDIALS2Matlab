addpath('MatlabFunc');
addpath( './functions');

clear all;
clc

%time interval
tStart =0;
tFin = 50;
%init state
x0 = [1;1];

N = 100; % nr. of integration steps in each interval from multiple shooting.
M = 10; % number of intervals 

%one time initialization/build/compile integrator
InitODE( 'lotka_volterraCasADi',tStart , tFin/( N * M ) );

% inp.sd -- initial value for differential states $x_0$
XX0 = repmat( [x0], 1, M );

%ODE parameters ( per ODE integration call )
p = [ 2/3;4/3;1;1];

%control ( just some dummy variable... used to build some dummy control
%vector )
u = [ 0 ];
%building a vecror of control parameters for all NXM intervals ( the ideea
%is that you can have different control paramiters for each integration
%call )
uu = repmat(u , 1, N);
uuu = repmat(uu, 1, M);

inp.N = N;
inp.M = M;

%inp.sd -- initial value for differential states $x_0$
inp.sd = XX0;

%inp.q -- constant control for integration horizon
inp.q = uuu;

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

%inp.sensdirs -- sensitivity directions in form of matrix
inp.sensdirs = eye(inp.nx + inp.np)

% set the number of threads for the thread pool used by the integrator
% ( I think it can also be done in a distributed way too... but I'm not
% quite sure... )
inp.threads = 1;

result_DM = integrateWSensitivites(inp);
result_fx = full(result_DM.xf);
result_G = full(result_DM.G);

%debug purpose
fprintf('%50s: result %s ', 'Integration', ...
    sprintf('%d ', result_fx) );
