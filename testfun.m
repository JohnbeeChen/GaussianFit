function varargout = testfun(width,varargin)

validScalarPosNum = @(x) isnumeric(x) && isscalar(x) && (x > 0);
p = inputParser;
% p.addRequired('width',validScalarPosNum);
% p.addOptional('width',1,validScalarPosNum);
p.addOptional('height',1,validScalarPosNum);
p.addParameter('Display','off');
p.parse(varargin{:});
p.Results
t = 1;

end