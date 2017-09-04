function varargout = GaussianFit2D(varargin)

fit_img = varargin{1};
fit_img_size = size(fit_img);
if fit_img_size(1) ~= fit_img_size(2)
   disp('error in fitting: the shape of the ROI is not a square!');
   varargout{1} = [];
   return;
end
max_value = max(fit_img(:));
min_value = min(fit_img(:));
[row,column] = find(fit_img == max_value);
x = 1:fit_img_size(2), y = 1:fit_img_size(1);
[X,Y] = meshgrid(x,y);


init_parameters = single([max_value, row, column, 1, min_value]);