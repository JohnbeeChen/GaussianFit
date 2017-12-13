function [] = circle(center,r,varargin)
%plot a circle with knowned center point and radius

x = center(:,1);
y = center(:,2);
num = size(center,1);
if nargin == 3
    clo = varargin{1};
else    
    clo = 'k';
end
for ii = 1:num
    rectangle('Position',[x(ii)-r,y(ii)-r,2*r,2*r],'Curvature',[1,1],'EdgeColor',clo);
end
axis equal