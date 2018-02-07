%this program is used to calulte the center of each fram in a image stack
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
fit_stack = gray2photon_coefficent*img_set{1};
fitre = StacksFitting(fit_stack,pixe_size);
xc = pixe_size*fitre{1,1}(:,2);
yc = pixe_size*fitre{1,1}(:,3);
figure
plot(xc,yc,'rx');
xlabel('x/nm');
ylabel('y/nm');
axis equal
grid minor
