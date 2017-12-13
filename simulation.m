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

total_photon = 200;
pixel_size = 65;
psf_fwhm = 230;% fwhm = 2.355*sigma in Gaussian distribution
bg_offset = 55; % bg means background
bg_noise = 1;% @bg_noise means the standard deviation of Gaussian noise
sigma = psf_fwhm/2.355;
sd = sigma/pixel_size;
img_size = [25,25];

x0 = 13;
y0 = 13;
z0 = 0;
sdx = sd;
sdy = sd;
display_flag = 0;

for ii = 1:100
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
end

pathname = 'simudata.tif';
immultifwrite(pathname,simu_img,16);
% the threshold of Rsquare
thres = 0.5;
rsqure = ft_result(:,7);
idx1 = rsqure >= thres;

good_result = ft_result(idx1,:);

tem = good_result(:,2:3);
std_xy = std(tem,0,1);
radiu = pixel_size*sqrt(std_xy*std_xy');
figure;
% cen = pixel_size*([x0,y0] +0.4);
cen = pixel_size*mean(tem);
plot(cen(1),cen(2),'Kx','MarkerSize',14);
circle(cen,radiu);
hold on
plot(pixel_size*tem(:,1),pixel_size*tem(:,2),'r*');
mean_precision = mean(precision(:,6));
title(['radius is ',num2str(radiu),';precision is ',num2str(mean_precision)]);