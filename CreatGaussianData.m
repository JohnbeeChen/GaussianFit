function varargout = CreatGaussianData(varargin)
% notice: x direction means Column, and y direction means row

ft = varargin{1};
img_size = varargin{2};

x = 1:img_size(1);
y = 1:img_size(2);

[X,Y] = meshgrid(x,y);
p = ft(1)*exp(-(X-ft(2)).^2/(2*ft(4)^2)-(Y-ft(3)).^2/(2*ft(5)^2)) +ft(6);
varargout{1} = p;
% surf(p)
% xlabel('x');
% ylabel('y');
