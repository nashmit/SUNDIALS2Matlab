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

%number of threads
nrThreads = 2;

%one time initialization/build/compile integrator
InitODEWSensitites('lotka_volterraCasADi',tStart , tFin/( M ), M, nrThreads);

% inp.sd -- initial values for differential states $x_0$
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

%sensdirs -- sensitivity directions in form of matrix
sensdirs1 = eye(inp.nx + inp.np);
sensdirs2 = diag([1:7]);


%directional matrix sensdirs1
fwd = sensdirs1;
%split between number of componentx of x_0 and number of components of
%the parameters
inp.fwd_x0 = fwd(:,1:inp.nx);
inp.fwd_p = fwd(:,inp.nx+1:inp.nx+inp.np);


%directional matrix sensdirs2
%fwd = sensdirs2;
%split between number of componentx of x_0 and number of components of
%the parameters
%inp.fwd_x0 = [inp.fwd_x0; fwd(:,1:inp.nx) ];
%inp.fwd_p = [inp.fwd_p; fwd(:,inp.nx+1:inp.nx+inp.np)];

%number of sensitivity directions
inp.nr_sensdirs = 1;
%if one wants to compute for more sensitivity directions, he must
%concatenate the split components ( fwd_x0 / dwd_p ) of all sensitivity
%directions and increase nr_sensdirs like it is done previously.


result = integrateWSensitivites(inp);
result_G = result.result_fwd_xf;
result_fx = result.result_xf;

%debug purpose
fprintf('%50s: result %s ', 'Integration', ...
    sprintf('%d ', result_fx) );
