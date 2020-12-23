function dx = diff_secondorder(t,x)

[m,n] = size(x);
dx = zeros(m,n);

dx(1) = x(2);
dx(2) = (2-2*t*x(2)-3*x(1))/(1+t^2);
end