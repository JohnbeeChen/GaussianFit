function [fitresult,precision] = GaussianFit2dCPU(fit_img,pixel_size,varargin)
%{ GaussianFit2dCPU(fit_img,pixel_size,display_flag)
% 2D Gaussian fitting and estimate the precision of the center of the Fit
% @display_flag: 1 for display, 0 for no dsplay (default)
% OutPut:
%     fitresult = [amp,centroid_x0,centroid_y0,(standar deviation x, y),z0,rsquar];
%     precision = [phton_number, background noise, pixle_size*(sd_x,sd_y),(precision_x,y)];
% Author @Johnbee<Tianjiu@pku.edu.cn> 11/16/2017
%}

display_flag = 0;
if nargin >= 3
    display_flag = varargin{1};
end
if nargin == 4
    file_name = varargin{2};
end
fit_img_size = size(fit_img);
x = 1:fit_img_size(2);
y = 1:fit_img_size(1);
[X,Y] = meshgrid(x,y);
[xData, yData, zData] = prepareSurfaceData( X, Y, fit_img );

%% Set up fittype and options.
formula = 'z0 + amp*exp(-(x-x0).^2/(2*sigma^2)-(y-y0).^2/(2*sigma^2))';
% ft = fittype( 'z0 + amp*exp(-(x-x0).^2/(2*sigma^2)-(y-y0).^2/(2*sigma^2))', 'independent', {'x', 'y'}, 'dependent', 'z' );
ft = fittype(formula, 'independent', {'x', 'y'}, 'dependent', 'z' );

opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
% opts = fitoptions( 'Method', 'Trust-Region' );
opts.Algorithm = 'Levenberg-Marquardt';
opts.Display = 'Off';
% opts.Lower = [0 0 0 0 0];
% [centroid,amp_int] = FindCentroid(fit_img);

amp_int = max(fit_img(:));
min_value = min(fit_img(:));
[y0,x0] = find(fit_img == amp_int);

% opts.StartPoint = [amp_int sd_int x0_int y0_int min(z(:))];
opts.StartPoint = [amp_int 1 x0(1) y0(1) min_value];

% Fit model to data.
[ft, gof] = fit([xData, yData], zData, ft, opts);

% backgraound = gof.rmse;
photon_number = ft.amp*2*pi*(ft.sigma)^2;
backgraound = BackNoiseEstimate(fit_img);

pk = pixel_size;
sd = pk*ft.sigma;

delta = CalculatePrecision(photon_number,backgraound,pk,sd);

%% Output
fitresult = [ft.amp,ft.x0,ft.y0,ft.sigma,ft.sigma,ft.z0,gof.rsquare];
precision = [photon_number,backgraound,sd,sd,delta,delta];

%% Plot fit with data.
if display_flag == 1
    figure( 'Name', 'untitled fit 1' );
    h = plot( ft, [xData, yData], zData );
    legend( h, 'untitled fit 1', 'fit_img vs. X, Y', 'Location', 'NorthEast' );
    if nargin >= 4
        til_str = file_name;
        title([til_str,',Rsquare is',num2str(gof.rsquare)]);
    else       
        title(['Rsquare is',num2str(gof.rsquare)]);
    end
    % Label axes
    xlabel X
    ylabel Y
    zlabel fit_img
    grid on
    view( 175.0, 14.0 );
end
end


function delta = CalculatePrecision(N,b,a,s)

tem = s^2/N + a^2/12/N + 8*pi*s^4*b^2/(a^2*N^2);
% sigma_sq = (s^2 + a^2/12)/N;
% tem1 = sigma_sq*(16/9+8*pi*sigma_sq*b^2/(a^2)); 
% sqrt(tem1);
delta = sqrt(tem);
% t = 1;
end