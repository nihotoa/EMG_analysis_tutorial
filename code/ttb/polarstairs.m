function H  = polarstairs(ax,x,y,varargin)

x   = shiftdim(x);
y   = shiftdim(y);

nx  = length(x);
ny  = length(y);

if(nx~=ny)
    error('XとYのデータ数が違いますｌ');
end 

dx  = abs(repmat(x,1,nx) - repmat(x',nx,1));

dx(dx==0)     = NaN;
dx  = min(min(dx));

XData   = [x-dx/2, x+dx/2];
YData   = [y,y];

XData   = reshape(XData',1,numel(XData));
YData   = reshape(YData',1,numel(YData));

XData   = [XData,XData(1)];
YData   = [YData,YData(1)];

% if(nargin<1)
%     h   = polar(ax,XData,YData);
% else
%     h   = polar(ax,XData,YData,varargin(:));
% end

    h   = polar(ax,XData,YData);
if(nargin>1)
    set(h,varargin{:});
end


if(nargout>0)
    H   = h;
end