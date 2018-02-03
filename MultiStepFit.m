function varargout = MultiStepFit(imgMultiStep,gray2Photon,pixelSize,dispFlag)
%% this function suit for multi-step image stack

pixe_size = pixelSize;
stack_num = length(imgMultiStep);
init_flag = 1;
fitresult = zeros(stack_num,7);
precise = zeros(stack_num,6);
stac_img_num = zeros(stack_num,1);
ii = stack_num;
while ii>0
    temp_img = gray2Photon*imgMultiStep{ii};
    stac_img_num(ii) = size(temp_img,3);
    fit_img = sum(temp_img,3);
    
    if init_flag %fit the last step witch only have one molecule
        [fitresult(ii,:),precise(ii,:)] = GaussianFit2dCPU(fit_img,pixe_size,dispFlag);
        %         ft = fitresult(ii,:);
        init_flag = 0;
        %         figure
        %         surf(fit_img);
    else
        img_size = size(temp_img(:,:,1));
        for jj = (ii+1):stack_num
            ft = fitresult(jj,:);%gets the fit result of last time fitting
            ft(6) = 0; % set the offset @ft(6) to 0 for creating a perfect Gassian distribution without offset
            p = CreatGaussianData(ft,img_size);
            %             p = CreatePSF(ft,img_size);
            tem = 1*stac_img_num(ii)./stac_img_num(jj);
            fit_img = fit_img - tem*p;
        end
        %         figure
        %         surf(fit_img);
        [fitresult(ii,:),precise(ii,:)] = GaussianFit2dCPU(fit_img,pixe_size,dispFlag);
    end
    ii = ii - 1;
end
varargout{1} = InverSort(fitresult);
varargout{2} = InverSort(precise);
end

function varargout = InverSort(inMat)

len = size(inMat,1);
y = zeros(size(inMat));
for ii = 1:len
    y(len-ii+1,:) = inMat(ii,:);
end
varargout{1} = y;
end