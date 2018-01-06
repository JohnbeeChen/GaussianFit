function varargout = Tiff2movie(varargin)

imgs = varargin{1};
len = size(imgs,3);
fps = varargin{2};
videoname = 'new.avi';
aviobj = VideoWriter(videoname);
aviobj.FrameRate = fps;
open(aviobj);

for ii = 1:len
    frame = im2double(imgs(:,:,ii));
    maxv = max(frame(:));
    minv = min(frame(:));
    frame = (frame-minv)/(maxv-minv);
    writeVideo(aviobj,frame);
end
close(aviobj);