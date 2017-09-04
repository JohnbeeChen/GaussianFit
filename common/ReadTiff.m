function varargout = ReadTiff(varargin)
% reads out the tiff files from the path in @varargin{1}

file_name = varargin{1};

imag_statck_num = length(file_name);
img_set = cell(imag_statck_num,1);
for ii = 1:imag_statck_num
    img_set{ii} = imreadstack_TIRF(file_name{ii},1);
end
varargout{1} = img_set;