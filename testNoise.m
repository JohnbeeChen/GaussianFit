% this program is to simulate the noise level
close all;
clear;
addpath([cd '/GpuFit64']);
addpath([cd '/Johnbee']);

total_photon = 10000;
pixel_size = 32.5;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
psf_fwhm = 350;% fwhm = 2.355*sigma in Gaussian distribution
bg_offset = 100; % bg means background
bg_noise = 50;% @bg_noise means the standard deviation of Gaussian noise
sigma = psf_fwhm/2.355;
sd = sigma/pixel_size;
img_size = [25,25];

x0 = 13;
y0 = 13;
z0 = 0;
sdx = sd;
sdy = sd;
display_flag = 1;
gray2photon_coefficent = 1;

total_photon = poissrnd(total_photon);%simultates the poisson noise
amp = total_photon./(2*pi*sd.^2);
% amp = 81;
ft = [amp,x0,y0,sdx,sdy,z0];
p = CreatGaussianData(ft,img_size); 
noise = normrnd(bg_offset,bg_noise,img_size);

p = p + noise;% simulates the Gaussian noise
[ftre,frpre] = GaussianFit2dCPU(p,pixel_size,display_flag);


