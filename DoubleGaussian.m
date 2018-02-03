parm1 = [10,4,0.5,5];
parm2 = [10,5.5,0.5,5];
x = 1:0.1:10;
close all
y1 = Gaussian(x,parm1);
y2 = Gaussian(x,parm2);
y = y1+y2;
figure
plot(x,y);
% figure
% plot(x,y1);

function y = Gaussian(x,parmeter)

A = parmeter(1);
x0 = parmeter(2);
sig = parmeter(3);
z0 = parmeter(4);

y = A*exp(-(x-x0).^2/(2*sig)) + z0;

end