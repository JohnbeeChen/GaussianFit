clear;
close all
gray2photon = 0.46/0.7;
Tiff_path = GetTiffFilePaths();
Tiff_file = gray2photon*imreadstack_TIRF(Tiff_path{1},1);
std(Tiff_file(:))
idx = Tiff_file == 0;
temimg = Tiff_file(~idx);
std(temimg)
fftimg = fft2(Tiff_file);
imagesc(abs(fftimg));
ofz = 20;
sz = size(fftimg);
new_fft = fftimg;
idy = ofz+1:sz(1)-ofz;
idx = ofz+1:sz(2)-ofz;
new_fft(idy,idx) = 0;
figure;
imagesc(abs(new_fft));
noise_img = ifft2(new_fft);
figure;
imagesc(abs(noise_img));

% len = size(Tiff_file,3);
% tem(1200) = 0;
% tic
% for ii = 1:len
%     temimg = Tiff_file(:,:,ii);
% %     temimg = sum(temimg,3);
%     tem(ii) = std(temimg(:));
% end
% toc