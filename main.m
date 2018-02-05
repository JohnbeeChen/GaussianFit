close all;
clear;
clc;
addpath(cd);
addpath([cd '/data']);
addpath([cd '/GpuFit64']);
addpath([cd '/common']);
addpath([cd '/ReadROI']);
addpath('Class');

% @display = 1 means display the fit result, 0 for not
display_flag = 1;
average_flag = 0;

pixe_size = 32.5;%for SIM and TIRF with interpolation
% pixe_s5ize = 65;%for TIRF with no interpolation

% 1 photon = 0.82 electron, 1 electron = 2.2 intensity
gray2photon_coefficent = 1/(0.82*2.2);


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
if average_flag
    fit_img1 = fit_img1./img_num1;
end


img2 = img_set{2} - pixe_offset;
img_num2 = size(img2,3);
fit_img2 = zeros(size(img2(:,:,1)));

for ii = 1:img_num2
    fit_img2 = fit_img2 + img2(:,:,ii);
end
if average_flag
    fit_img2 = fit_img2./img_num2;
end
[fitresult2,precise2] = GaussianFit2dCPU(fit_img2,pixe_size,display_flag);


size_img1  = size(fit_img1);
ft = fitresult2;
ft(6) = 0;
if average_flag
    fit_img3 = fit_img1 - CreatGaussianData(ft,[size_img1(2) size_img1(1)]);
else
    fit_img3 = fit_img1 - img_num1./img_num2*CreatGaussianData(ft,[size_img1(2) size_img1(1)]);  
end
[fitresult3,precise3] = GaussianFit2dCPU(fit_img3,pixe_size,display_flag);


%fitresult = [amp,centroid_x0,centroid_y0,(standar deviation x, y),z0,Rsqure];
%precision = [phton_number, background noise, pixle_size*(sd_x,sd_y),(precision_x,y)];
fitresult = [fitresult2;fitresult3];
precise = [precise2; precise3];

