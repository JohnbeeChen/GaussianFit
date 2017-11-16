function varargout = Localization_Precise(fit_result,pixe_size)

points_num = size(fit_result,1);
uncer = zeros(points_num,2);
tem_points = fit_result;

for jj = 1 : points_num
    amp = tem_points(jj,1);
    std = tem_points(jj,4:5);% standard deviation(x,y)

    bg_noise = fit_result(jj,7);
    photons_num = 2*pi*amp*std(1)*std(2);
%     photons_num = fit_result(jj,8);
    uncer(jj,:) = calculate_uncertain(pixe_size*std,pixe_size,bg_noise,photons_num);
end

varargout{1} = uncer;
% varargout{2} = [photons_num,bg_noise];

end

function y = calculate_uncertain(sd,a,b,N)
term = zeros(3,2);

term(1,:) = sd.^2/N;
term(2,:) = a.^2/12/N;
term(3,:) = 8*pi*b.^2.*sd.^4/(a.^2 * N.^2);

uncertain = sqrt(sum(term));

y = uncertain;
end