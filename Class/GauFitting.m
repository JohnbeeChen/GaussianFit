classdef GauFitting < handle
    %{
        GauFitting class is used to single molecular Gaussian fitting
        Version: 1.0 <2018/02/28>
        Author:  Johnbee<Tianjiu@pku.edu.cn>
    %}
    properties
        PixelSize
        Gray2Photon
    end
    methods
        function obj = GauFitting(varargin)
            % new a GauFitting object, obj = @(pixelSize,gray2Photon);
            validScalarPosNum = @(x) isnumeric(x) && isscalar(x) && (x > 0);
            ip = inputParser;
            ip.addOptional('pixelSize',1,validScalarPosNum);
            ip.addOptional('gray2Photon',1,validScalarPosNum);
            ip.parse(varargin{:});
            obj.PixelSize = ip.Results.pixelSize;
            obj.Gray2Photon = ip.Results.gray2Photon;
        end
        function [fitresult,precision] = GaussianFit2dCPU(obj,fit_img,varargin)
            %{
            GaussianFit2dCPU(fit_img)
            2D Gaussian fitting and estimate the precision of the center of the Fit
            @display_flag: 1 for display, 0 for no dsplay (default)
            OutPut:
                fitresult = [amp,centroid_x0,centroid_y0,(standar deviation x, y),z0,rsquar];
                precision = [phton_number, background noise, pixle_size*(sd_x,sd_y),(precision_x,y)];
            %}
            ip = inputParser;
            ip.addParameter('DisplayFlag','off');
            ip.addParameter('Title','');
            ip.parse(varargin{:});
            display_flag = ip.Results.DisplayFlag;
            fit_title = ip.Results.Title;
            fit_img = obj.Gray2Photon*fit_img;
            
            fit_img_size = size(fit_img);
            x = 1:fit_img_size(2);
            y = 1:fit_img_size(1);
            [X,Y] = meshgrid(x,y);
            [xData, yData, zData] = prepareSurfaceData( X, Y, fit_img );
            
            %% Set up fittype and options.
            formula = 'z0 + amp*exp(-(x-x0).^2/(2*sigma^2)-(y-y0).^2/(2*sigma^2))';
            ft = fittype(formula, 'independent', {'x', 'y'}, 'dependent', 'z' );
            opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
            opts.Algorithm = 'Levenberg-Marquardt';
            opts.Display = 'Off';
            amp_int = max(fit_img(:));
            min_value = min(fit_img(:));
            [y0,x0] = find(fit_img == amp_int);
            opts.StartPoint = [amp_int 1 x0(1) y0(1) min_value];
            
            % Fit model to data.
            [ft, gof] = fit([xData, yData], zData, ft, opts);
            photon_number = ft.amp*2*pi*(ft.sigma)^2;
            backgraound = GauFitting.BackNoiseEstimate(fit_img);
            
            pk = obj.PixelSize;
            sd = pk*ft.sigma;
            
            delta = GauFitting.CalculatePrecision(photon_number,backgraound,pk,sd);
            
            %% Output
            fitresult = [ft.amp,ft.x0,ft.y0,ft.sigma,ft.sigma,ft.z0,gof.rsquare];
            precision = [photon_number,backgraound,sd,sd,delta,delta];
            
            %% Plot fit with data.
            if strcmpi(display_flag,'on')
                figure( 'Name', fit_title );
                h = plot( ft, [xData, yData], zData );
                legend( h, 'untitled fit 1', 'fit_img vs. X, Y', 'Location', 'NorthEast' );
                title(['Rsquare is',num2str(gof.rsquare)]);
                % Label axes
                xlabel X
                ylabel Y
                zlabel fit_img
                grid on
                view( 175.0, 14.0 );
            end
        end        
        function varargout = MultiStepFit(obj,imgMultiStep,varargin)
            % this function suit for multi-step image stack
            ip.addParameter('DisplayFlag','off');
            ip.parse(varargin{:});
            dispFlag = ip.Results.DisplayFlag;
            gray2Photon = obj.Gray2Photon;
            pixe_size = obj.PixelSize;
            
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
                    init_flag = 0;
                else
                    img_size = size(temp_img(:,:,1));
                    for jj = (ii+1):stack_num
                        ft = fitresult(jj,:);%gets the fit result of last time fitting
                        ft(6) = 0; % set the offset @ft(6) to 0 for creating a perfect Gassian distribution without offset
                        p = CreatGaussianData(ft,img_size);
                        tem = 1*stac_img_num(ii)./stac_img_num(jj);
                        fit_img = fit_img - tem*p;
                    end
                    [fitresult(ii,:),precise(ii,:)] = GaussianFit2dCPU(fit_img,pixe_size,dispFlag);
                end
                ii = ii - 1;
            end
            varargout{1} = fitresult(end:-1:1,:);
            varargout{2} = precise(end:-1:1,:);
        end
    end
    methods (Access = private)
        
    end
    methods(Static)
        function delta = CalculatePrecision(N,b,a,s)
            %this function is used to Calculate the precision of the gaussian
            %fitting result
            tem = s^2/N + a^2/12/N + 8*pi*s^4*b^2/(a^2*N^2);
            delta = sqrt(tem);
        end
        function varargout = CreatGaussianData(varargin)
            % varargin{1} = [amp,x0,y0,sd_x,sd_y,z0];
            % varargin{2} = [data size in y direction, ...in x direction];
            % notice: in images, x direction means Column and y direction means row
            
            ft = varargin{1};
            img_size = varargin{2};
            x = 1:img_size(2);
            y = 1:img_size(1);
            
            [X,Y] = meshgrid(x,y);
            p = ft(1)*exp(-(X-ft(2)).^2/(2*ft(4)^2)-(Y-ft(3)).^2/(2*ft(5)^2)) +ft(6);
            varargout{1} = p;
        end
        function varargout = BackNoiseEstimate(imgNoise)
            % this function is used to estimate the background noise of the input image
            % bg_noise = @(input image)
            % Johnbee<Tianjiu@pku.edu.cn> 2018/02/03
            %
            fft_p = fftshift(fft2(imgNoise));
            mag = abs(fft_p);
            [fft_high,fraction] = GauFitting.KeepHighFreq(mag);
            a = numel(imgNoise);
            t = sum(fft_high(:).^2)/a.^2;
            estimate_bg = sqrt(t./fraction);
            
            varargout{1} = estimate_bg;
            
        end
        function varargout = KeepHighFreq(fftImag)
            %this funcion is used to set the maximum circle region in the Fourier plane
            % of the @fftImag to 0
            % [fft plane with high frequency, the ratio of maximum cicle] = @(fft_plane)
            sz = size(fftImag);
            min_sz = min(sz);
            radius = max(min_sz)/2;
            center = (sz+1)/2;
            
            new_fft = fftImag;
            x = 1:sz(2);
            y = 1:sz(1);
            [X,Y] = meshgrid(x,y);
            
            dis = (Y-center(1)).^2 + (X-center(2)).^2;
            idx = dis < radius.^2;
            new_fft(idx) = 0;
            fraction = sum(~idx(:))/numel(idx);
            
            varargout{1} = new_fft;
            varargout{2} = fraction;
        end
    end
end