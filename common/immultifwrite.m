function immultifwrite(savepath, savedata, imagebit, varargin)
%UNTITLED 此处显示有关此函数的摘要
%  Author: Li Jinghang<ljhis007@pku.edu.cn>
t = Tiff(savepath,'w');
if nargin == 4
    maxpage = varargin{1};
else
    maxpage = size(savedata,3);
end
for s_idx = 1:maxpage
    t.setTag('Photometric', Tiff.Photometric.MinIsBlack);
    t.setTag('Software', 'MATLAB');
    t.setTag('Compression', Tiff.Compression.None);
    t.setTag('PlanarConfiguration', Tiff.PlanarConfiguration.Chunky);
    
    %imwrite(image_all,now_save_path);
    if imagebit == 16
        t.setTag('ImageLength',size(uint16(savedata(:,:,s_idx)),1));
        t.setTag('ImageWidth', size(uint16(savedata(:,:,s_idx)),2));
        t.setTag('BitsPerSample', 16);
        t.setTag('SamplesPerPixel', 1);
        
        t.write(uint16(savedata(:,:,s_idx)));
    else
        if imagebit == 8
            t.setTag('ImageLength',size(uint8(savedata(:,:,s_idx)),1));
            t.setTag('ImageWidth', size(uint8(savedata(:,:,s_idx)),2));
            t.setTag('BitsPerSample', 8);
            t.setTag('SamplesPerPixel', 1);
            
            t.write(uint8(savedata(:,:,s_idx)));
        end
    end
    
    t.writeDirectory();
end
t.close();

end

