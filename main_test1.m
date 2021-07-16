addpath('MatlabFunc');
addpath( './functions');

clear all
clc

%init state
x0 = [pi/6;0];

%time interval
tphi = 0;
tfin = 500;

%tic
[t,x] = ode45( 'Pendulum', [tphi tfin] , x0 );
f = @()ode45( 'Pendulum', [tphi tfin] , x0 );
timeit(f)
%toc

%cheching the output!
%disp(x(end,1));disp(x(end,2));


%figure (1)
%size(x)
%plot( t, x(:,1) );
%plot( x(:,1), x(:,2) )
%hold on

%N represents the number of intermediate points for plotting/integration step...
%I'm using this number for a 'fair' comparison...
[N,~] = size(t)
%%InitODE( 'PendulumCasADi',tphi , tfin/N );
InitODE( 'PendulumCasADi',tphi , tfin );

global s2m;
F = s2m.integrator;
%disp(F);
%trigger the integrator N times for [ tphi , tfin] time interval
%%sim = F.mapaccum(N);
sim = F;

%r = sim(x0,[],[],[],[],[]);
%r(:,N)
%sol = full(r);

%tic
r = sim('x0',x0,'p',[],'z0',[],'rx0',[],'rp',[],'rz0',[]);
f = @()sim('x0',x0,'p',[],'z0',[],'rx0',[],'rp',[],'rz0',[]);
timeit(f)
%toc

%cheching the output!
%disp(r.xf);

%size(r)

%sol = full(r.xf);
%figure (2)
%plot(sol(1,:),sol(2,:))
%hold on