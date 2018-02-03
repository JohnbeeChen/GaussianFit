function varargout = ReadExcel(varargin)

pathname = varargin{1};

[numdata,txtdata,rawdata] = xlsread(pathname);
varargout = {numdata,txtdata,rawdata};

end