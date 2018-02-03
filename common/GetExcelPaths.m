function varargout = GetExcelPaths(varargin)

if exist('lastfile.mat','file')
    P=importdata('lastfile.mat');
    pathname=P.pathname;
else
    pathname=cd;
end
[filename, pathname] = uigetfile( ...
    {'*.xls;*.xlsx', 'All Execl-Files (*.xls,*.xlsx)'; ...
    '*.*','All Files (*.*)'}, ...
    'Select Excel File',pathname,'MultiSelect','on');
if isequal([filename,pathname],[0,0])
    disp('file path is not correct!');
    varargout{1} = [];
    return
end
full_filename = fullfile(pathname,filename);
if ~iscell(full_filename)
    tem{1} = full_filename;
    clear full_filename;
    full_filename{1} = tem{1};  
end
varargout{1} = full_filename;
% save('lastfile.mat','pathname','filename');