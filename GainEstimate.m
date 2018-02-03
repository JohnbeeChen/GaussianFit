%% this program is to estimate the gain of the device
%% input the beads image stack to estimate the gain of camera
close all;
clear;
clc;
addpath([cd '/data']);
addpath([cd '/GpuFit64']);
addpath([cd '/common']);
addpath([cd '/ReadROI']);

% @displya_flag = 1 for plot the fitting result, 0 for not
display_flag = 0;

% @pixle_size means the 
pixle_size = 87;

Tiff_path = GetTiffFilePaths();
Tiff_file = ReadTiff(Tiff_path);

imag_statck_num = length(Tiff_path);
%% reads imgae's statcks and processes
hw = waitbar(0);
for ii = 1:imag_statck_num
    tem_stack = Tiff_file{ii};
    img_fit = mean(tem_stack,3);
    [fstresult,~] = GaussianFit2dCPU(img_fit,pixle_size,display_flag);
    tem_stack = tem_stack - fstresult(6);
    img_num = size(tem_stack,3);
    for jj = 1: img_num
%         [ftresult,~] = GaussianFit2dCPU(tem_stack(:,:,jj),pixle_size,display_flag);
%         tem = tem_stack(:,:,jj) - ftresult(6);
        tem = tem_stack(:,:,jj);
        Inten(jj) = sum(tem(:));
    end
    waitbar(ii/imag_statck_num);
    data(ii,:) = [mean(Inten),var(Inten),var(Inten)/mean(Inten)];
    
    clear Inten;    
end
close(hw);
figure;
plot(data(:,1),data(:,2),'r*');