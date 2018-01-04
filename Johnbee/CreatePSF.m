function varargout = CreatePSF(varargin)
% Create PSF distribution with intergrate
% varargin{1} = [amp,x0,y0,sd_x,sd_y,z0];
% varargin{2} = [data size in y direction, ...in x direction];
% notice: in images, x direction means Column and y direction means row


ft = varargin{1};
img_size = varargin{2};
img = zeros(img_size);
ft(2:3) = ft(2:3);
x = 0.55:0.1:(img_size(2)+0.45);
y = 0.55:0.1:(img_size(1)+0.45);

[X,Y] = meshgrid(x,y);
p = ft(1)*exp(-(X-ft(2)).^2/(2*ft(4)^2)-(Y-ft(3)).^2/(2*ft(5)^2)) + ft(6);
for ii = 1:img_size(1)
    idx = ((ii-1)*10+1) : (ii*10);
   for jj =1:img_size(2) 
       idy = ((jj-1)*10+1) : (jj*10);
       tem = p(idx,idy);
       img(ii,jj) = sum(tem(:))./100;
   end
end
varargout{1} = img;

end