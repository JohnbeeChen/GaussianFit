function y = CalculatePrecise(N,s,a,b)

tem1 = s.^2 ./N;
tem2 = a.^2./(N*12);
tem3 = 8*pi*s.^4 * b.^2./(a.^2 * N.^2);
y = sqrt(tem1 + tem2 + tem3);