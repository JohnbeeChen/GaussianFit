%% this program handles the data of qinghua
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

% pixel_size = 32.5;%for SIM and TIRF with interpolation
pixel_size = 65;%for TIRF without interpolation

% 1 photon = 0.82 electron, 1 electron = 2.2 intensity
% gray2photon = 1/(0.82*2.2);
% 1 photon = 0.7 electron, 0.46 electron = 1 intensity
gray2photon = 0.46/0.7;
% gray2photon = 1;

Tiff_path = GetTiffFilePaths();
Tiff_file = imreadstack_TIRF(Tiff_path{1},1);
ROI_path = GetROIPaths();
ROI_set = ReadROI(ROI_path);
Excel_path = GetExcelPaths();
Step_point = ReadExcel(Excel_path{1});
len = size(Step_point,1);
roi = ROI_set{1};
roi_stac = ROI_Cutor(Tiff_file,roi);

run Qinhua2.m;


