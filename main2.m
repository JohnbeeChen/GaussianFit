%% this program handles the situation of multi-folder
close all;
clear;
clc;
addpath([cd '/data']);
addpath([cd '/GpuFit64']);
addpath([cd '/common']);
addpath([cd '/ReadROI']);
addpath([cd '/Johnbee']);

% @display = 1 means display the fit result, 0 for not
display_flag = 1;
average_flag = 0;

pixel_size = 32.5;%for SIM and TIRF with interpolation
% pixe_s5ize = 65;%for TIRF without interpolation

% 1 photon = 0.82 electron, 1 electron = 2.2 intensity
gray2photon = 1/(0.82*2.2);

if exist('lastpath.mat','file')
    start_path = importdata('lastpath.mat');
else
    start_path=cd;
end
folder_path = uigetdir(start_path);
all_file_name = findfiles(folder_path,'tif');
for ii = 1:length(all_file_name)
    file_name = all_file_name{1};
    img_set = ReadTiff(file_name);
    img_set = img_set(1:(end-1));
    [ft,pre] = MultiStepFit(img_set,gray2photon,pixel_size,display_flag);
    t = 1;
end
delta_xy = ft(1,2:3)-ft(2,2:3);
tem = pixel_size*sqrt(delta_xy*delta_xy');
disp(['delata loc:',num2str(tem)]);

save('lastpath.mat','folder_path');

function varargout = MultiStepFit(imgMultiStep,gray2Photon,pixelSize,dispFlag)
%% this function suit for multi-step image stack

pixe_size = pixelSize;
stack_num = length(imgMultiStep);
init_flag = 1;
fitresult = zeros(stack_num,7);
precise = zeros(stack_num,6);
stac_img_num = zeros(stack_num,1);
ii = stack_num;
while ii>0
    temp_img = gray2Photon*imgMultiStep{ii};
    stac_img_num(ii) = size(temp_img,3);
    fit_img = sum(temp_img,3);
    
    if init_flag %fit the last step witch only have one molecule
        [fitresult(ii,:),precise(ii,:)] = GaussianFit2dCPU(fit_img,pixe_size,dispFlag);
        %         ft = fitresult(ii,:);
        init_flag = 0;
        figure
        surf(fit_img);
    else
        img_size = size(temp_img(:,:,1));
        for jj = (ii+1):stack_num
            ft = fitresult(jj,:);%gets the fit result of last time fitting
            ft(6) = 0; % set the offset @ft(6) to 0 for creating a perfect Gassian distribution without offset
            p = CreatGaussianData(ft,img_size);
%             p = CreatePSF(ft,img_size);
            tem = 0.6*stac_img_num(ii)./stac_img_num(jj);
            fit_img = fit_img - tem*p;
        end      
        figure
        surf(fit_img);
        [fitresult(ii,:),precise(ii,:)] = GaussianFit2dCPU(fit_img,pixe_size,dispFlag);
    end
    ii = ii - 1;
end
varargout{1} = fitresult;
varargout{2} = precise;
end
