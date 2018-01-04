%simulation for fit the two partical molecule
close all;
clear;

display = 1;
a = 32.5;
sz = [25,25];
mole1_loc = [10,10];
mole2_loc = [10.5,10.5];
width = 90;
bg_noise = 50;
bg_offset = 200;

sigma = width/(2.355*a);
ft1 = [500,mole1_loc,sigma,sigma,0];
ft2 = [800,mole2_loc,sigma,sigma,0];
bi_data = CreatGaussianData(ft1,sz) + CreatGaussianData(ft2,sz);
noise = normrnd(bg_offset,bg_noise,sz);
bi_data = bi_data + noise;

ft3 = [1000,mole1_loc,sigma,sigma,0];
si_data = CreatGaussianData(ft3,sz) + normrnd(220,50,sz);
[ft_re(1,:),ft_pre(1,:)] = GaussianFit2dCPU(si_data,a,display,'molecule 1');

ft4 = ft_re;
ft4(6) = 0;
% fit_data = bi_data - 0.6*CreatePSF(ft4,sz);
fit_data = bi_data - 0.3*CreatGaussianData(ft4,sz);
[ft_re(2,:),ft_pre(2,:)] = GaussianFit2dCPU(fit_data,a,display,'molecule 2');

% [bi_re,bi_pre] = GaussianFit2Mole(bi_data,ft_re,a,display,'bi molecule fit');

figure;
surf(fit_data);
