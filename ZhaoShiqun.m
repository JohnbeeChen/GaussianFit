%% this program only run for ZhaoShiqun
close all;
clear;
clc;
addpath([cd '/data']);
addpath([cd '/GpuFit64']);
addpath([cd '/common']);
addpath([cd '/ReadROI']);

%% some parameters can be set
% @TIRF_falg = 1 means that the input imgaes are from TIRF with interpolation
TIRF_flag = 0;

% @displya_flag = 1 for plot the fitting result, 0 for not
display_flag = 0;

% @pixle_size means the 
pixle_size = 87;
% pixle_size = 67; %for Qinghua
% parameters of the camere, sets according to the real device
ADU = 11.86;
QE = 0.95;
EMgain = 2000;

%% the code followed not allow modification
gray2photon_coefficent = ADU/(QE*EMgain);
% gray2photon_coefficent = 1/(0.46*0.7);% for Qinghua

%% reads the last time opened file's path
if exist('lastfile.mat','file')
    P=importdata('lastfile.mat');
    pathname=P.pathname;
else
    pathname=cd;
end
[filename, pathname] = uigetfile( ...
    {'*.tif;*.tiff', 'All TIF-Files (*.tif,*.tiff)'; ...
    '*.*','All Files (*.*)'}, ...
    'Select Image File',pathname,'MultiSelect','on');
if isequal([filename,pathname],[0,0])
    disp('file path is not correct!');
    return
end
imag_statck_num = length(filename);
img_set = cell(1,imag_statck_num);
full_filename = fullfile(pathname,filename);
if ~iscell(full_filename)
    tem{1} = full_filename;
    clear full_filename;
    full_filename{1} = tem{1};
    imag_statck_num = 1;
end

%% reads imgae's statcks and processes
for ii = 1:imag_statck_num   
    tem = gray2photon_coefficent*sum(imreadstack_TIRF(full_filename{ii},1),3);
    if TIRF_flag == 1
       sz = size(tem);
       idx_row = 1:2:sz(1);
       idx_col = 1:2:sz(2);
       tem = tem(idx_row,idx_col);
    end
    img_set_sum{ii} = tem;
    [ftresult(ii,:),precise(ii,:)] = GaussianFit2dCPU(tem,pixle_size,display_flag);    
end
ft_column_name = {'Amp','x0','y0','sigma_x','sigma_y','z0','Rsquare'};
pre_column_name = {'phton number', 'background noise','width_x','width_y','delta_x','delta_y'};

str = [pathname 'fit_info.xls'];
SaveExcel(str,ftresult,ft_column_name);
str = [pathname 'precision_info.xls'];
SaveExcel(str,precise,pre_column_name);

disp('finished!');
save('lastfile.mat','pathname','filename');