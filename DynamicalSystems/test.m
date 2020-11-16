addpath( '../functions');
init()

import casadi.*

x = MX.sym('x',2); % Two states
y = MX.sym('y');

f = Function('f',{x},{sin(x)});
g = Function('g',{x},{cos(x)});


opts = struct('mex', true); %'main', true,

Code = CodeGenerator('GeneratedCode.c',opts);

Code.add(f);
Code.add(g);

Code.generate();

compiled = Importer('GeneratedCode.c','clang');

FF = external('f',compiled);
GG = external('g',compiled);

FF(3.14/2)
GG(3.14/2)