addpath('MatlabFunc');
addpath( './functions');

clear all;
clc

%time interval
tStart =0;
tFin = 30000;
%init state
x0 = [2;0];

%tic
[t,y] = ode15s('vdp1000',[tStart tFin], x0 );
f = @()ode15s('vdp1000',[tStart tFin], x0 );
timeit(f)
%toc

%figure (1)
%plot(t,y(:,1),'-');
%title('Solution of van der Pol Equation, mu = 1000');
%xlabel('time t');
%ylabel('solution y(:,1)');
%hold on;


[N,~] = size(t)
InitODE( 'vdp1000CasADi',tStart , tFin/N );

global s2m;
F = s2m.integrator;

disp(F);

sim = F.mapaccum(N);

%tic
f = @()sim('x0',x0,'p',[],'z0',[],'rx0',[],'rp',[],'rz0',[]);
timeit(f)
%toc
r = sim('x0',x0,'p',[],'z0',[],'rx0',[],'rp',[],'rz0',[]);

sol = full(r.xf);

%time = linspace(tStart,tFin,N);
%figure (2)
%plot(time,sol(1,:),'-');
%hold on