function varargout = StacksFitting(inStacks,pixelSize)

pixe_size = pixelSize;
img_num = size(inStacks,3);
sum_img = 0;

%fit for every fram
for ii = 1:img_num
    fit_img = inStacks(:,:,ii);
    sum_img = sum_img + fit_img;
    [fram_ft(ii,:),fram_precision(ii,:)] = GaussianFit2dCPU(fit_img,pixe_size);
end
% fit for averag_img
    average_img = sum_img/img_num;
    [average_ft,average_precision] = GaussianFit2dCPU(average_img,pixe_size);
% fit for sum_img
    [sum_ft,sum_precision] = GaussianFit2dCPU(sum_img,pixe_size); 
    out{1,1} = fram_ft;
    out{1,2} = fram_precision;
    out{2,1} = average_ft;
    out{2,2} = average_precision;    
    out{3,1} = sum_ft;
    out{3,2} = sum_precision;
    
    varargout{1} = out;
end