function varargout = BackNoiseEstimate(imgNoise)
% this function is used to estimate the background noise of the input image
% bg_noise = @(input image)
% Johnbee<Tianjiu@pku.edu.cn> 2018/02/03

fft_p = fftshift(fft2(imgNoise));
mag = abs(fft_p);
[fft_high,fraction] = KeepHighFreq(mag);
a = numel(imgNoise);
t = sum(fft_high(:).^2)/a.^2;
estimate_bg = sqrt(t./fraction);

varargout{1} = estimate_bg;

end

function varargout = KeepHighFreq(fftImag)
% this funcion is used to set the maximum circle region in the Fourier plane 
% of the @fftImag to 0
% [fft plane with high frequency, the ratio of maximum cicle] = @(fft_plane)

sz = size(fftImag);
min_sz = min(sz);
radius = max(min_sz)/2;
center = (sz+1)/2;

new_fft = fftImag;
x = 1:sz(2);
y = 1:sz(1);
[X,Y] = meshgrid(x,y);

dis = (Y-center(1)).^2 + (X-center(2)).^2;
idx = dis < radius.^2;
new_fft(idx) = 0;
fraction = sum(~idx(:))/numel(idx);

varargout{1} = new_fft;
varargout{2} = fraction;
end