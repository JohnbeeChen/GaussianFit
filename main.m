close all;
clear;
clc;
addpath([cd '/data']);
addpath([cd '/GpuFit64']);
addpath([cd '/common']);
addpath([cd '/ReadROI']);

pixe_size = 32.5;
gray2photon_coefficent = 1/(0.8*0.46);
% gray2photon_coefficent = 30;

file_name = GetTiffFilePaths();
img_set = ReadTiff(file_name);
%convert intensity to photon number
for ii = 1:3
   img_set{ii} = gray2photon_coefficent*img_set{ii};  
end
offset_img = img_set{3};
offset_img_size = size(offset_img);
tem = offset_img_size(1)*offset_img_size(2)*offset_img_size(3);
pixe_offset = sum(offset_img(:))/(tem);

img1 = img_set{1} - pixe_offset;

img_num1 = size(img1,3);
fit_img1 = zeros(size(img1(:,:,1)));

for ii = 1:img_num1
   fit_img1 = fit_img1 + img1(:,:,ii); 
end
fit_img1 = fit_img1./img_num1;
[fitresult1,~] = GaussianFit2dCPU(fit_img1);
[precise1] = Localization_Precise(fitresult1,pixe_size);

img2 = img_set{2} - pixe_offset;
img_num2 = size(img2,3);
fit_img2 = zeros(size(img2(:,:,1)));

for ii = 1:img_num2
   fit_img2 = fit_img2 + img2(:,:,ii); 
end
fit_img2 = fit_img2./img_num2;
[fitresult2,~] = GaussianFit2dCPU(fit_img2);
[precise2] = Localization_Precise(fitresult2,pixe_size);

size_img1  = size(img1);
fit_img3 = fit_img1 - CreatGaussianData(fitresult2,[size_img1(2) size_img1(1)]);

[fitresult3,~] = GaussianFit2dCPU(fit_img3);
[precise3] = Localization_Precise(fitresult3,pixe_size);
precitse = [precise1; precise2; precise3];

fit_result = [fitresult1; fitresult2; fitresult3];
result = [fit_result(:,1:8),precitse];


figure;
subplot(1,3,1);
surf(fit_img1);
% axis equal;
subplot(1,3,2);
surf(fit_img2);
% axis equal;
subplot(1,3,3);
surf(fit_img3);
% axis equal;
