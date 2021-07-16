addpath( './functions');

%InitDAE( 'testDAE',0,1.1 );
InitODE( 'testODE',0,0.5 );

global s2m;
F = s2m.integrator;

%parameters with the same meaning used in CasADi documentation.
%https://web.casadi.org/docs/

x0 = 0.1;       %Initial differential state
z0 = 0;         %Initial algebraic variable
p  = 0.1;       %Independent parameter
u0 = 0;         %control


disp(F);
r = F('x0',x0,'z0',z0,'p',p);
%r = F('x0',x0);

%result of integration...
%disp(r)
disp(r.xf)

% Calculate one directional derivative, forward mode
I_fwd = F.factory('I_fwd', {'x0', 'z0', 'p', 'fwd:p'}, {'fwd:xf', 'fwd:qf'});

res = I_fwd('x0', x0, 'p', u0, 'fwd_p', 1);
fwd_xf = full(res.fwd_xf);
fwd_qf = full(res.fwd_qf);
fprintf('%50s: d(xf)/d(p)=%s, d(qf)/d(p)=%s\n', 'Forward sensitivities', ...
    sprintf('%d ', fwd_xf), sprintf('%d ', fwd_qf));

% Calculate one directional derivative, reverse mode
I_adj = F.factory('I_adj', {'x0', 'z0', 'p', 'adj:qf'}, {'adj:x0', 'adj:p'});
res = I_adj('x0', x0, 'p', u0, 'adj_qf', 1);
adj_x0 = full(res.adj_x0);
adj_p = full(res.adj_p);
fprintf('%50s: d(qf)/d(x0)=%s, d(qf)/d(p)=%s\n', 'Adjoint sensitivities', ...
            sprintf('%d ', adj_x0), sprintf('%d ', adj_p));

