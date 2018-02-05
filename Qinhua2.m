clear ft_precise ft_result tem
display_flag = 0;
for ii = 1:len
    tem_sp = Step_point(ii,:);
    tem_roi = roi(tem_sp(5),:);
    tem_stac = roi_stac{ii};
    img_set{1} = tem_stac(:,:,tem_sp(1):tem_sp(2));
    img_set{2} = tem_stac(:,:,tem_sp(3):tem_sp(4));
    
    img_set = KeepImagstacLength(img_set,20);
    [ft,pre] = MultiStepFit(img_set,gray2photon,pixel_size,display_flag);
    delta_xy = ft(1,2:3)-ft(2,2:3);
    tem(ii) = pixel_size*sqrt(delta_xy*delta_xy');
    %     disp(['delata loc:',num2str(tem(ii))]);
    ft_result{ii} = ft;
    ft_precise{ii} = pre;
end
ft_result = cell2mat(ft_result');
ft_precise = cell2mat(ft_precise');
tem = tem';
tem_a(1:2:2*len,1) = tem;
tem_a(2:2:2*len,1) = tem;
figure
histogram(tem);
mean(tem)

function varargout = KeepImagstacLength(imgStack,myLen)

if myLen < 1
    varargout{1} = [];
    return
end
img1 = imgStack{1};
img2 = imgStack{2};
len1 = size(img1,3);
len2 = size(img2,3);
len = min([len1,len2,myLen]);
img1 = img1(:,:,end-len+1:end);
img2 = img2(:,:,1:len);
varargout{1} = {img1,img2};
end