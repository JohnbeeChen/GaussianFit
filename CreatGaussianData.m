function varargout = CreatGaussianData(varargin)
% varargin{1} = [amp,x0,y0,sd_x,sd_y,z0];
% varargin{2} = [data number in x direction, ...in y direction];
% notice: in images, x direction means Column and y direction means row

ft = varargin{1};
img_size = varargin{2};
img = zeros(img_size);

x = 0.1:0.1:img_size(1);
y = 0.1:0.1:img_size(2);

[X,Y] = meshgrid(x,y);
p = ft(1)*exp(-(X-ft(2)).^2/(2*ft(4)^2)-(Y-ft(3)).^2/(2*ft(5)^2)) +ft(6);
for ii = 1:img_size(1)
    idx = ((ii-1)*10+1) : (ii*10);
   for jj =1:img_size(2) 
       idy = ((jj-1)*10+1) : (jj*10);
       tem = p(idx,idy);
       img(ii,jj) = sum(tem(:))./100;
   end
end
varargout{1} = img;



% ft = varargin{1};
% img_size = varargin{2};
% 
% x = 1:img_size(1);
% y = 1:img_size(2);
% 
% [X,Y] = meshgrid(x,y);
% p = ft(1)*exp(-(X-ft(2)).^2/(2*ft(4)^2)-(Y-ft(3)).^2/(2*ft(5)^2)) +ft(6);
% varargout{1} = p;
