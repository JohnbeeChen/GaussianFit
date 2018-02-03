% this program is to simulate the noise level
close all;
clear;
addpath([cd '/GpuFit64']);
addpath([cd '/Johnbee']);

total_photon = 1000;
pixel_size = 32.5;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
psf_fwhm = 90;% fwhm = 2.355*sigma in Gaussian distribution
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
display_flag = 0;
gray2photon_coefficent = 1;

total_photon = poissrnd(total_photon);%simultates the poisson noise
amp = total_photon./(2*pi*sd.^2);
% amp = 81;
ft = [amp,x0,y0,sdx,sdy,z0];
p = CreatGaussianData(ft,img_size); 
noise = normrnd(bg_offset,bg_noise,img_size);

p = p + noise;% simulates the Gaussian noise
bg = BackNoiseEstimate(p);
% p = noise;
% figure;
% surf(p);
% fft_p = fftshift(fft2(p));
% 
% mag = abs(fft_p);
% [fft_high,fraction] = KeepHighFreq(mag,1);
% figure;
% imagesc(fft_high);
% 
% a = prod(img_size);
% t = sum(fft_high(:).^2)/a.^2;
% estima_bg = sqrt(t./fraction)
% fft_p = fft2(p);
% figure;
% surf(abs(fftshift(fft_p)));
% [fft_high,fraction] = KeepHighFreq(fftshift(fft_p),2);
% figure;
% surf(abs(fft_high));
% % figure
% % surf(abs(ifftshift(fft_high)));
% new_p = abs(ifft2(ifftshift(fft_p)));
% err = new_p - p;
% 
% high_power = (abs(fft_high)/(25*25)).^2;
% noise_var = sum(high_power(:))*0.2256
% 
% % std(new_p(:))/fraction
% 
function varargout = KeepHighFreq(fftImag,edg_off)

ofz = edg_off;

sz = size(fftImag);
min_sz = min(sz);
radius = max(min_sz)/2;
center = (sz+1)/2;

new_fft = fftImag;
x = 1:sz(2);
y = 1:sz(1);
[X,Y] = meshgrid(x,y);

dis = (Y-center(1)).^2 + (X-center(2)).^2;
idx = dis < radius.^2;
new_fft(idx) = 0;
fraction = sum(~idx(:))/numel(idx);
% idy = ofz+1:sz(1)-ofz;
% idx = ofz+1:sz(2)-ofz;
% new_fft(idy,idx) = 0;
% block_sz = sz - 2*ofz;
% fraction = 1 - prod(block_sz)./prod(sz);
% fraction = prod(sz)-prod(block_sz);
varargout{1} = new_fft;
varargout{2} = fraction;
end


% close all;
% fs = 100; %sample frequecy
% N = 512;
% n = 0:N-1;
% t = n/fs;
% x = 0.5*cos(2*pi*15*t) + 2*sin(2*pi*40*t) + 1;
% y = fft(x,N);
% mag = abs(fftshift(y));
% f = n*fs/N;
% subplot(2,1,1);
% plot(f,mag);
% grid on
% subplot(2,1,2);
% plot(f(1:N/2),mag(1:N/2));
% grid on

