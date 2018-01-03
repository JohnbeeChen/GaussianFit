% this code is to simulate the uncertianty formula derived by Bernd Rieger
close all;
clear;
addpath([cd '/GpuFit64']);
addpath([cd '/Johnbee']);

total_photon = 10000;
pixel_size = 65;
psf_fwhm = 250;% fwhm = 2.355*sigma in Gaussian distribution
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
display_flag = 1;

par0 = [x0*65,y0*65,sigma,0,total_photon];
% 1 photon = 0.82 electron, 1 electron = 2.2 intensity
% gray2photon_coefficent = 1/(0.82*2.2);
gray2photon_coefficent = 1;


for ii = 1:1
if ii == 1
   display_flag = 1;
else
    display_flag = 0;
end
% total_photon = poissrnd(total_photon);%simultates the poisson noise
amp = total_photon./(2*pi*sd.^2);
ft = [amp,x0-0.5,y0-0.5,sdx,sdy,z0];
p = CreatGaussianData(ft,img_size); 
noise = normrnd(bg_offset,bg_noise,img_size);

p = p + noise;% simulates the Gaussian noise
simu_img(:,:,ii) = p;
% imagesc(p);
% figure;
% surf(p);
[ft_result(ii,:),precision(ii,:)] = GaussianFit2dCPU(p,pixel_size,display_flag);
min_z0 = min(p(:));
b = ft_result(ii,6) - min_z0;
s = precision(ii,3);
a = pixel_size;
N = precision(ii,1);
w1 = (s.^2 + a.^2/12)/N;
tou = 2*pi*b*w1/(a^2);
w2 = 1+4*tou + sqrt(2*tou/(1+4*tou));
w3 = 16/9 + 4*tou;
delta_x1 = sqrt(w1*w2);
delta_x2 = sqrt(w1*w3);
if display_flag
   title(['Rsquare:',num2str(ft_result(ii,end))]); 
end
t  = 1;
end

[par,uncer] = MLEwG(p,par0,65,1,1,bg_offset);