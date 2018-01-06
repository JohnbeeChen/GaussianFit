% this program is to simulate the photon's distribution of single molecule
close all;
clear;
addpath([cd '/GpuFit64']);
addpath([cd '/Johnbee']);

% total_photon = 14200;
% pixel_size = 86;
% psf_fwhm = 287;% fwhm = 2.355*sigma in Gaussian distribution
% bg_offset = 100; % bg means background
% bg_noise = 11;% @bg_noise means the standard deviation of Gaussian noise
% sigma = psf_fwhm/2.355;
% sd = sigma/pixel_size 
% img_size = [25,25];

total_photon = 1000;
pixel_size = 32.5;
psf_fwhm = 90;% fwhm = 2.355*sigma in Gaussian distribution
bg_offset = 100; % bg means background
bg_noise = 10;% @bg_noise means the standard deviation of Gaussian noise
sigma = psf_fwhm/2.355;
sd = sigma/pixel_size;
img_size = [25,25];

x0 = 13;
y0 = 13;
z0 = 0;
sdx = sd;
sdy = sd;
display_flag = 0;
% 1 photon = 0.82 electron, 1 electron = 2.2 intensity
% gray2photon_coefficent = 1/(0.82*2.2);
gray2photon_coefficent = 1;

for ii = 1:100
if ii == 1
   display_flag = 1;
else
    display_flag = 0;
end
total_photon = poissrnd(total_photon);%simultates the poisson noise
amp = total_photon./(2*pi*sd.^2);
ft = [amp,x0,y0,sdx,sdy,z0];
p = CreatGaussianData(ft,img_size); 
noise = normrnd(bg_offset,bg_noise,img_size);

p = p + noise;% simulates the Gaussian noise
simu_img(:,:,ii) = p;
% imagesc(p);
% figure;
% surf(p);
[ft_result(ii,:),precision(ii,:)] = GaussianFit2dCPU(p,pixel_size,display_flag);
if display_flag
   title('gaaghg'); 
end
t  = 1;
end

% pathname = 'simudata.tif';
% immultifwrite(pathname,simu_img,16);
% the threshold of Rsquare
thres = 0;
rsqure = ft_result(:,7);
idx1 = rsqure >= thres;

good_result = ft_result(idx1,:);

tem = good_result(:,2:3);
std_xy = std(tem,0,1);
radiu = pixel_size*sqrt(std_xy*std_xy');
figure;

cen = pixel_size*mean(tem);
cen_c = pixel_size*[x0,y0];
dis = cen-cen_c;
distance = sqrt(dis*dis');
plot(pixel_size*tem(:,1),pixel_size*tem(:,2),'r*');
hold on
plot(cen(1),cen(2),'rx','MarkerSize',16);
circle(cen,radiu,'r');
hold on
plot(cen_c(1),cen_c(2),'kx','MarkerSize',16);
mean_precision = mean(precision(:,6));
title(['distance:',num2str(distance),' radius:',num2str(radiu),' precision:',num2str(mean_precision)]);
grid minor