function [ satisx, satisxdelta, satisxmax, satisxmin, accbnd, bndedgenp ] = threcomp( xxx, yyy, yrange, interpswitch, xrange )
% [ satisx, satisxdelta, satisxmax, satisxmin, accbnd, bndedgenp ] = threcomp( xxx, yyy,[-0.2 0.2], 'on',[-inf inf] )
%   For yyy=f(xxx), this function selects elements in xxx, namely the satisx, ...
%     which satisfy the conditions of f(satisx), yrange and xrange.
%   When xxx is sparse, please turn the interpswitch 'on' to find a more accurate...
%     boundary for satisx.
if nargin<5, xrange=[-inf inf];end
if nargin<4, interpswitch='off';end
if length(xxx)~=length(yyy)
    error('diffeerent lengths');
end

yyy=yyy( (xxx>xrange(1)) & (xxx<xrange(2)));
xxx=xxx( (xxx>xrange(1)) & (xxx<xrange(2)));

satisx=xxx( (yyy>yrange(1)) & (yyy<yrange(2)));
satisxmax=max(satisx);
satisxmin=min(satisx);
accbnd=[];
bndedgenp=[];    

if strcmp('off',interpswitch)
    satisxdelta=satisxmax-satisxmin;
    accbnd=0;
    bndedgenp=0;
else
%     ind((ind~=circshift(ind,[0 1])) | (ind~=circshift(ind,[0 -1])))=-1
%     imax = find(max(y) == y);
    for ii=1:length(xxx)-1
        if  (yyy(ii) > yrange(1)) && (yyy(ii) < yrange(2))
           if  (yyy(ii+1) <= yrange(1))   
               beta=abs(yrange(1)-yyy(ii))/abs(yyy(ii+1)-yyy(ii));
               xsbnd=xxx(ii)+abs(xxx(ii+1)-xxx(ii))*beta;
               accbnd=[accbnd xsbnd];
               bndedgenp=[bndedgenp -1];
           else if (yyy(ii+1) >= yrange(2))
               beta=abs(yrange(2)-yyy(ii))/abs(yyy(ii+1)-yyy(ii));
               xsbnd=xxx(ii)+abs(xxx(ii+1)-xxx(ii))*beta;
               accbnd=[accbnd xsbnd];
               bndedgenp=[bndedgenp -1];   
               end
           end
        else if (yyy(ii) <= yrange(1)) && ...
                    (yyy(ii+1) > yrange(1)) && (yyy(ii+1) < yrange(2))
               beta=abs(yrange(1)-yyy(ii))/abs(yyy(ii+1)-yyy(ii));
               xsbnd=xxx(ii)+abs(xxx(ii+1)-xxx(ii))*beta;
               accbnd=[accbnd xsbnd];
               bndedgenp=[bndedgenp 1];
            else if (yyy(ii) >= yrange(2)) && ...
                        (yyy(ii+1) > yrange(1)) && (yyy(ii+1) < yrange(2))
               beta=abs(yrange(2)-yyy(ii))/abs(yyy(ii+1)-yyy(ii));
               xsbnd=xxx(ii)+abs(xxx(ii+1)-xxx(ii))*beta;
               accbnd=[accbnd xsbnd];
               bndedgenp=[bndedgenp 1];
                end
            end
        end
    end
    satisxdelta=max(accbnd(-1==bndedgenp)) - min(accbnd(1==bndedgenp));           
        
end
    
end

