addpath('MatlabFunc');
addpath( './functions');

clear all;
clc

%time interval
tStart =0;
tFin = 300;
%init state
x0 = [1;1];

%ODE parameters
p = [ 2/3;4/3;1;1];

%control ( just some dummy variable... used to build some dummy control
%vector )
u = [ 0.15 ];

parameters_and_control = [u; p];

[t,x]=ode23(@(t,y) lotka_volterra(t,y,parameters_and_control),[tStart tFin],x0 );
f=@()ode23(@(t,y) lotka_volterra(t,y,parameters_and_control),[tStart tFin],x0 );
timeit(f)

disp( [ x(end,1) x(end,2) ] );

[N,~] = size(t)

%one time initialization/build/compile integrator
InitODE( 'lotka_volterraCasADi',tStart , tFin );

global s2m;
F = s2m.integrator;

sim = F;

%tic
r = sim('x0',x0,'p',parameters_and_control,'z0',[],'rx0',[],'rp',[],'rz0',[]);
f = @()sim('x0',x0,'p',parameters_and_control,'z0',[],'rx0',[],'rp',[],'rz0',[]);
timeit(f)
%toc

sol = full(r.xf)

