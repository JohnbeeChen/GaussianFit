function SaveExcel(varargin)
%input [path, data, columnName, rowName]

str = varargin{1};
data = varargin{2};
sz = size(data);
if nargin == 2
    data_excel = num2cell(data);   
elseif nargin == 3
    colum_name = varargin{3};
    data_excel = cell(sz(1)+1,sz(2));
    data_excel(1,1:end) = colum_name;
    data_excel(2:end,1:end) = num2cell(data);
elseif nargin == 4
    colum_name = varargin{3};
    row_name = varargin{4};
    data_excel = cell(sz(1)+1,sz(2)+1);
    data_excel(1,2:end) = colum_name;
    data_excel(2:end,1) = row_name;
    data_excel(2:end,2:end) = num2cell(data);
end
xlswrite(str,data_excel);


% [fName,pName,index] = uiputfile('*.xlsx','Save as','data_1.xlsx');
% if index && strcmp(fName(end-4:end),'.xlsx')
%     str = [pName fName];
%     data = get(handles.uitable1,'data');
%     data_excel = cell(sz(1), sz(2));
%     data_excel(1,2:end) = get(handles.uitable1,'ColumnName');
%     data_excel(2:end,1) = get(handles.uitable1,'RowName');
%     data_excel(2:end,2:end) = num2cell(data);
%     xlswrite(str,data_excel);
% else
%     disp('file path is not correct');
% end