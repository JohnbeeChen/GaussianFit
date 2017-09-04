close all;
clc;
addpath([cd '/data']);
addpath([cd '/GpuFit64']);
addpath([cd '/common']);
addpath([cd '/ReadROI']);

file_name = GetTiffFilePaths();
img_set = ReadTiff(file_name);

ROI_file_name = GetROIPaths();
roi_set = ReadROI(ROI_file_name);

img_set_num = length(img_set);
for ii = 1:img_set_num
    tem_img_set = img_set{ii};
    tem_roi_set = roi_set{ii};
    roi_set_num = size(tem_roi_set,1);
    for jj = 1:roi_set_num
        tem_roi = tem_roi_set(jj,:);
        fram_index = tem_roi(5);
        tem_img = tem_img_set(:,:,fram_index);
        fit_img = tem_img(tem_roi(2):tem_roi(4),tem_roi(1):tem_roi(3));
        fit_img_size = size(fit_img);
%         x = 1:fit_img_size(2), y = 1:fit_img_size(1);
%         [X,Y] = meshgrid(x,y);
        
        GaussianFit2dCPU(fit_img)
        t = 1;
    end
    
end