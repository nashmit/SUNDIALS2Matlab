addpath( './functions');

%InitODE( 'testODE' );
InitDAE( 'testDAE',0,1.1 );

global s2m;
F = s2m.integrator;

disp(F)

r = F('x0',0,'z0',0,'p',0.1);

disp(r.xf)
