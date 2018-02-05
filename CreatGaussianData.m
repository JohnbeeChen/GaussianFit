function varargout = CreatGaussianData(varargin)
% varargin{1} = [amp,x0,y0,sd_x,sd_y,z0];
% varargin{2} = [data size in y direction, ...in x direction];
% notice: in images, x direction means Column and y direction means row

ft = varargin{1};
img_size = varargin{2};

x = 1:img_size(2);
y = 1:img_size(1);

[X,Y] = meshgrid(x,y);
p = ft(1)*exp(-(X-ft(2)).^2/(2*ft(4)^2)-(Y-ft(3)).^2/(2*ft(5)^2)) +ft(6);
varargout{1} = p;
end