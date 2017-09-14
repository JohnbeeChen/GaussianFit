function y = CalculatePrecise(N,s,a,b)

tem = (s.^2 + a.^2/12)./N;
tem = tem + 8*pi*s.^4 * b.^2./(a.^2 * N.^2);
y = sqrt(tem);