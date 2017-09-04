function varargout = GetROIPaths()
% get the roi files path that you specified
% you can select one or more files in once 

if exist('lastfile.mat','file')
    P=importdata('lastfile.mat');
    pathname=P.pathname;
else
    pathname=cd;
end
[filename, pathname] = uigetfile( ...
    {'*.zip;*.roi', 'All zip-Files (*.zip,*.zip)'; ...
    '*.*','All Files (*.*)'}, ...
    'Select ROI File',pathname,'MultiSelect','on');
if isequal([filename,pathname],[0,0])
    disp('file path is not correct!');
    return
end
full_filename = fullfile(pathname,filename);
if ~iscell(full_filename)
    tem{1} = full_filename;
    clear full_filename;
    full_filename{1} = tem{1};  
end

varargout{1} = full_filename;
