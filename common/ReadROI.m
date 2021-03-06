function varargout = ReadROI(varargin)
% return [top_left(y,x) bottom_right(y,x) nPosition]
% notice: y means Row, x means Column
% notice: the loc in ImageJ start from 0, but Matlab start from 1
% Johnbee<Tianjiu@pku.edu.cn> 2018/01/25

filename = varargin{1};
roi_set_num = length(filename);
roi_set = cell(roi_set_num,1);
roi_name_set = cell(roi_set_num,1);

for ii = 1:roi_set_num
    rois = ReadImageJROI(filename{ii});
    roi_num = length(rois);
    box =zeros(roi_num,5);
    roi_names= cell(1,roi_num);
    if roi_num == 1
        box(1,1:4) = rois{1}.vnRectBounds;%[Top,Left,Bottom,Right]
        box(1,5) = rois{1}.nPosition;
        roi_names{1} = rois{1}.strName;
    elseif roi_num > 1
        for jj = 1:roi_num
            tem = rois{jj};
            box(jj,1:4) = tem.vnRectBounds;
            box(jj,5) = tem.nPosition;
            roi_names{jj} = tem.strName;
        end
    end
    % notice: the loc in ImageJ start from 0, but Matlab start from 1
    box(:,1:4) = box(:,1:4) + 1;
    roi_set{ii} = box;
    roi_name_set{ii} = roi_names;
end
varargout{1} = roi_set;
varargout{2} = roi_name_set;

