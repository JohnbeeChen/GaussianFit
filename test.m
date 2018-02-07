clear;
close all
% gray2photon = 0.46/0.7;
gray2photon = 1;
Tiff_path = GetTiffFilePaths();
Tiff_file = gray2photon*imreadstack_TIRF(Tiff_path{1},1,100);
fit_img = sum(Tiff_file,3);
std(fit_img(:))
% idx = Tiff_file == 0;
% temimg = Tiff_file(~idx);
% std = std(temimg)
estimate_std = GauFitting.BackNoiseEstimate(fit_img)

% fftimg = fft2(Tiff_file);
% imagesc(abs(fftimg));
% ofz = 5;
% sz = size(fftimg);
% new_fft = fftimg;
% idy = ofz+1:sz(1)-ofz;
% idx = ofz+1:sz(2)-ofz;
% new_fft(idy,idx) = 0;
% figure;
% imagesc(abs(new_fft));
% noise_img = ifft2(new_fft);
% figure;
% imagesc(abs(noise_img));

