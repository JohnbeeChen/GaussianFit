function varargout = ROI_Cutor(imgStac,roi)
% input @roi = [Top_left(y,x),Bottum_right(y,x)];

len = size(roi,1);
y = cell(len,1);
for ii = 1:len
    idy = roi(ii,1):roi(ii,3);
    idx = roi(ii,2):roi(ii,4);
    y{ii} = imgStac(idy,idx,:);
end
varargout{1} = y;