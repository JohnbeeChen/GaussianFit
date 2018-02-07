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
display_flag = 0;
average_flag = 0;

pixel_size = 32.5;%for SIM and TIRF with interpolation
% pixel_size = 65;%for TIRF without interpolation

% 1 photon = 0.82 electron, 1 electron = 2.2 intensity
gray2photon = 1/(0.82*2.2);
% 1 photon = 0.7 electron, 0.46 electron = 1 intensity
% gray2photon = 0.46/0.7;
% gray2photon = 1;
if exist('lastpath.mat','file')
    start_path = importdata('lastpath.mat');
else
    start_path=cd;
end
folder_path = uigetdir(start_path);
try
    all_file_name = findfiles(folder_path,'tif');
catch
    disp('folder invaild');
    return;
end
file_num = length(all_file_name);
tem(file_num) = 0;
ft_result{file_num} = [];
ft_precise{file_num} = [];

for ii = 1:file_num
    file_name = all_file_name{ii};
    img_set = ReadTiff(file_name);
%     img_set{1} = img_set{1}(:,:,(end-8):(end-2));
%     img_set{2} = img_set{2}(:,:,2:8);
    %     img_set = img_set(1:(end-1));
    [ft,pre] = MultiStepFit(img_set,gray2photon,pixel_size,display_flag);
    delta_xy = ft(1,2:3)-ft(2,2:3);
    tem(ii) = pixel_size*sqrt(delta_xy*delta_xy');
    %     disp(['delata loc:',num2str(tem(ii))]);
    ft_result{ii} = ft;
    ft_precise{ii} = pre;
%     ft_result(end:end+1,:) = ft;
%     ft_precise(end:end+1,:) = pre;
    t = 1;
end
ft_result = cell2mat(ft_result');
ft_precise = cell2mat(ft_precise');
tem_a(1:2:2*ii,1) = tem;
tem_a(2:2:2*ii,1) = tem;

%% saves data to execel
str_idx = strfind(folder_path,'\');
tem = folder_path(str_idx(end):end);
execel_name = [tem,'.xlsx'];
savedata = [ft_result,ft_precise,tem_a];
columname = {'amp','xc','yc','sigma x','sigma y','z0','Rsquare','Photon',...
             'bg noise','width x','width y','delta x','delta y','distance'};
SaveExcel([folder_path,execel_name],savedata,columname);
save('lastpath.mat','folder_path');

