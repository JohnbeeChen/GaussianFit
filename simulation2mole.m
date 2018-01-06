%% this code simulates the situation about two molecules bleaching
%% and yield the simulated images 
close all;
clear;
addpath([cd '/GpuFit64']);
addpath([cd '/Johnbee']);
addpath([cd '/common']);

display = 0;
a = 32.5;
sz = [15,15];
mole1_loc = [7,7];
mole2_loc = [7,7.1];
width = 90;
bg_noise = 5;
bg_offset = 5;

sigma = width/(2.355*a);
N1_constn = 150;
N2_constn = 140;

N1 = 150/(2*pi*sigma^2);
N2 = 140/(2*pi*sigma^2);

for ite = 1:100
num1 = 40;
for ii = 1:num1
    amp1 = poissrnd(N1_constn)/(2*pi*sigma^2);
    amp2 = poissrnd(N2_constn)/(2*pi*sigma^2);
    ft1 = [amp1,mole1_loc,sigma,sigma,0];
    ft2 = [amp2,mole2_loc,sigma,sigma,0];
    bi_data = CreatGaussianData(ft1,sz) + CreatGaussianData(ft2,sz);
%     bi_data = imnoise(bi_data,'poisson');
    noise = normrnd(bg_offset,bg_noise,sz);
    img1(:,:,ii) = bi_data+noise;
end
num2 = 30;
for ii = 1:num2
    amp2 = poissrnd(N2_constn)/(2*pi*sigma^2);
    ft2 = [amp2,mole2_loc,sigma,sigma,0];
    mole2_data = CreatGaussianData(ft2,sz);
    noise = normrnd(bg_offset,bg_noise,sz);
    img2(:,:,ii) = mole2_data+noise;
end

num3 = 30;
for ii = 1:num3
    noise = normrnd(bg_offset,bg_noise,sz);
    img3(:,:,ii) = noise;
end
% simu_img(:,:,1:num1) = img1;
% simu_img(:,:,(1:num2)+num1) = img2;
% simu_img(:,:,(1:num3)+num1+num2) = img3;

% tiffwrite(img1,'SIM_simu1.tif');
% tiffwrite(img2,'SIM_simu2.tif');
% tiffwrite(img3,'SIM_simu3.tif');
% tiffwrite(simu_img,'SIM_simu2mole.tif');

img_set{1} = img1;
img_set{2} = img2;
[tem_ft,tem_pre] = MultiStepFit(img_set,1,a,display);
ft([2*ite-1,2*ite],:) = tem_ft;
pre([2*ite-1,2*ite],:) = tem_pre;

delta_xy = tem_ft(1,2:3)-tem_ft(2,2:3);
tem(ite) = a*sqrt(delta_xy*delta_xy');
% disp(['delata loc:',num2str(tem)]);
end
mean(tem)
std(tem)
histogram(tem);
photon = pre(:,1);
photon1 = photon(1:2:end);
photon2 = photon(2:2:end);
precision = pre(:,5);
precision1 = precision(1:2:end);
precision2 = precision(2:2:end);

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
%         figure
%         surf(fit_img);
    else
        img_size = size(temp_img(:,:,1));
        for jj = (ii+1):stack_num
            ft = fitresult(jj,:);%gets the fit result of last time fitting
            ft(6) = 0; % set the offset @ft(6) to 0 for creating a perfect Gassian distribution without offset
            p = CreatGaussianData(ft,img_size);
%             p = CreatePSF(ft,img_size);
            tem = 1*stac_img_num(ii)./stac_img_num(jj);
            fit_img = fit_img - tem*p;
        end      
%         figure
%         surf(fit_img);
        [fitresult(ii,:),precise(ii,:)] = GaussianFit2dCPU(fit_img,pixe_size,dispFlag);
    end
    ii = ii - 1;
end
varargout{1} = fitresult;
varargout{2} = precise;
end
