addpath('MatlabFunc');
addpath( './functions');

clear all;
clc

x0=[-8 ;8; 27];
%tspan=[0,20];
tStart = 0;
tFin = 500;

[t,x]=ode45('lorenz',[tStart tFin],x0 );
f=@()ode45('lorenz',[tStart tFin],x0 );
timeit(f)

%print output!
%disp( [ x(end,1) x(end,2) x(end,3) ] );


%figure (1)
%plot(x(:,1),x(:,3),'o')
%hold on;

%subplot(3,1,1)
%plot(t,x(:,1))
%subplot(3,1,2)
%plot(t,x(:,2))
%subplot(3,1,3)
%plot(t,x(:,3))


[N,~] = size(t)
%%InitODE( 'lorenzCasADi',tStart , tFin/N );
InitODE( 'lorenzCasADi',tStart , tFin );

global s2m;
F = s2m.integrator;

%%disp(F);
%sim = F.mapaccum(N);
sim = F;

%tic
sim('x0',x0,'p',[],'z0',[],'rx0',[],'rp',[],'rz0',[]);
f = @()sim('x0',x0,'p',[],'z0',[],'rx0',[],'rp',[],'rz0',[]);
timeit(f)
%toc

r = sim('x0',x0,'p',[], 'z0',[],'rx0',[],'rp',[],'rz0',[]);

%print output!
%sol = full(r.xf)

%figure (2)
%plot(sol(1,:),sol(3,:),'o')
%hold on