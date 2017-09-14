
close all;
clear;
clc;
addpath([cd '/data']);
addpath([cd '/GpuFit64']);
addpath([cd '/common']);
addpath([cd '/ReadROI']);

pixe_size = 65;
gray2photon_coefficent = 1/(0.8*0.46);
% gray2photon_coefficent = 30;

file_name = GetTiffFilePaths();
img_set = ReadTiff(file_name);
%convert intensity to photon number
img_set{1} = gray2photon_coefficent*img_set{1};  

img1 = img_set{1};

img_num1 = size(img1,3);
fit_img1 = zeros(size(img1(:,:,1)));

for ii = 1:img_num1
   fit_img1 = fit_img1 + img1(:,:,ii); 
end
fit_img1 = fit_img1./img_num1;
a = 1:2:25;
fit_img1 = fit_img1(a,a);
[fitresult1,~] = GaussianFit2dCPU(fit_img1);
[precise1,gof1] = Localization_Precise(fitresult1,pixe_size);