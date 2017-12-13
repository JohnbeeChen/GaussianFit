%% test the precision of each fram of the imgage's stack

close all;
clear;
clc;
addpath([cd '/data']);
addpath([cd '/GpuFit64']);
addpath([cd '/common']);
addpath([cd '/ReadROI']);
addpath([cd '/Johnbee']);

% @display = 1 means display the fit result, 0 for not
display_flag = 0;
average_flag = 0;
% @TIRF_flag = 1: the input image stacks are TIRF, 0 for SIM
TIRF_flag = 0;

if TIRF_flag
    pixe_size = 65;%for TIRF with no interpolation 
    tem_idx = 1:2:25;
else    
    pixe_size = 32.5;%for SIM
end

% 1 photon = 0.82 electron, 1 electron = 2.2 intensity
gray2photon_coefficent = 1/(0.82*2.2);


file_name = GetTiffFilePaths();
if isempty(file_name)
    return;
end
img_set = ReadTiff(file_name);
%convert intensity to photon number
for ii = 1:3
    if TIRF_flag
    img_set{ii} = img_set{ii}(tem_idx,tem_idx,:);
    end
    img_set{ii} = gray2photon_coefficent*img_set{ii};

end

offset_img = img_set{3};
offset_img_size = size(offset_img);
tem = offset_img_size(1)*offset_img_size(2)*offset_img_size(3);
pixe_offset = sum(offset_img(:))/(tem);

img2 = img_set{2} - pixe_offset;
out2 = StacksFitting(img2,pixe_size);

average_ft = out2{2,1};
fitresult = [average_ft(1:5),0];
if TIRF_flag
    p = CreatGaussianData(fitresult,[13,13]);
else
    p = CreatGaussianData(fitresult,[25,25]);
end

% figure;
% surf(p);

img1 = img_set{1} - p;
out1 = StacksFitting(img1,pixe_size);


disp('finshed!');

% function varargout = TestParameter(inputImgs,pixelSize)
% 
% pixe_size = pixelSize;
% img_num = size(inputImgs,3);
% sum_img = 0;
% 
% %fit for every fram
% for ii = 1:img_num
%     fit_img = inputImgs(:,:,ii);
%     sum_img = sum_img + fit_img;
%     [fram_ft(ii,:),fram_precision(ii,:)] = GaussianFit2dCPU(fit_img,pixe_size);
% end
% % fit for averag_img
%     average_img = sum_img/img_num;
%     [average_ft,average_precision] = GaussianFit2dCPU(average_img,pixe_size);
% % fit for sum_img
%     [sum_ft,sum_precision] = GaussianFit2dCPU(sum_img,pixe_size); 
%     out{1,1} = fram_ft;
%     out{1,2} = fram_precision;
%     out{2,1} = average_ft;
%     out{2,2} = average_precision;    
%     out{3,1} = sum_ft;
%     out{3,2} = sum_precision;
%     
%     varargout{1} = out;
% end
