addpath('MatlabFunc');
addpath( './functions');

clear all
clc

tStart=0; 
tFin=500;

x0=[0; 1];

%tic
[t,x]=ode23('diff_secondorder', [tStart , tFin], x0);
f = @()ode23('diff_secondorder', [tStart , tFin], x0);
timeit(f)
%toc


%figure (1)
%plot(t,x);
%legend('x1','x2');

%check result!
%disp(x(end,1)); disp(x(end,2));


[N,~] = size(t)

InitODE( 'diff_secondorderCasADi',tStart , tFin );


global s2m;
F = s2m.integrator;

%%disp(F);

%%sim = F.mapaccum(N);
sim = F;


%tic
f = @()sim('x0',x0,'p',[],'z0',[],'rx0',[],'rp',[],'rz0',[]);
timeit(f)
%toc
r = sim('x0',x0,'p',[],'z0',[],'rx0',[],'rp',[],'rz0',[]);

sol = full(r.xf);

%check result!
%disp(sol);
