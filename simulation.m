% this program is to simulate the photon's distribution of single molecule
close all;
clear;
addpath([cd '/GpuFit64']);

total_photon = 14200;
pixe_size = 86;
psf_fwhm = 287;% fwhm = 2.355*sigma in Gaussian distribution
bg_offset = 100; % bg means background
bg_noise = 11;% @bg_noise means the standard deviation of Gaussian noise
sigma = psf_fwhm/2.355;
sd = sigma/pixe_size;

total_photon = poissrnd(total_photon);%simultates the poisson noise
amp = total_photon./(2*pi*sd.^2);
amp = 14200;
x0 = 13;
y0 = 13;
z0 = bg_offset;
% z0 = 0;
sdx = sd;
sdy = sd;
ft = [amp,x0,y0,sdx,sdy,z0];
p = CreatGaussianData(ft,[25,25]);
p = normrnd(p,bg_noise);% simulates the Gaussian noise
surf(p);
[ft_result,~] = GaussianFit2dCPU(p);
precise = Localization_Precise(ft_result,pixe_size);
result = [ft_result,precise];