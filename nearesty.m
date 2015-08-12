function [y0,minindex] = nearesty( xxx,yyy,x0,interpswitch )
%   yyy=f(xxx)
%   find y0=f(x0)
%   xxx is the monotonical increasing argument
if length(xxx)~=length(yyy)
    error('vector length must agree.');
end
if nargin<4, interpswitch='on'; end

[mimima1,minindex]=min(abs(xxx-x0));

if minindex==1
    y0=yyy(1);
else if minindex==length(xxx)
        y0=yyy(length(xxx));
    else if strcmp('off',interpswitch)
            y0=yyy(minindex);
        else if xxx(minindex)>x0
                x1=minindex-1;
                x2=minindex;
            else
                x1=minindex;
                x2=minindex+1;
            end
            beta=(yyy(x2)-yyy(x1))/(xxx(x2)-xxx(x1));
            y0=yyy(x1)+(x0-xxx(x1))*beta;
        end
    end
end
            

            
        



end

