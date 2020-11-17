function [xwidthdraw, profiledraw, xpeakdraw, peakdraw] = profileAnalyzor1d(xaxis, profilelin, normode, xpeak, widthlevel, logsw, intpsw, figsw)
% 20200927 v1
% analyze the directivity & beamwidth of a pattern or specturm, peak should not at left or right side  
% 一维方向图或频谱图的波束宽度计算（可插值），暂不支持峰值靠边的情况
% example:
% xwidthdraw = profileAnalyzor1d(drg, pat);
% [xwidthdraw, profiledraw, xpeakdraw, peakdraw] = profileAnalyzor1d(drg, 10.^(pat/20),'as is',2,0.1,1,1,3);
% input: 
%     xaxis, freq axis or direction axis
%     profilelin, linear data input (1-order, for 20*log10)
%     normode, figure type
%                 'as is', without any modification (default)
%                 'max norm', normalization using peak value
%                 'avg norm', normalization using mean value
%                 'gain norm', normalization using 3D average radiated power, used for gain/directivity/dBi
%                               assumption: profilelin is for -90~90 deg
%                               (1/sqrt(2))*(radiated power) (avg for 2-order and -90~90 deg)
%                               !! attention!! 3D total radiated power for 1D array along x-axis == C1*sum(pattern.*cos(theta)) ~= C2*sum(pattern)
%                 a number, normalization using the given value
%     xpeak, the x position of the peak
%                 'measured', calculate from data
%                 a number, user defined, fuzzy supported
%     widthlevel, level of the width measurement, 1/sqrt(2) is the default value
%     logsw, logstate
%                 1, log output  (default)
%                 others, linear output
%     intpsw, perform interpolation (10x resample) or not
%                 1, yes, fix the peak x position, peak value, and the measured width (default)
%                 others, no
%     figsw, showing the figure or not
%                 1, yes, (default)
%                 others, no
% output:
%     xwidthdraw, measured width (may be normalized)
%     profiledraw, data in the figure (may be normalized)
%     xpeakdraw, peak x position in the figure (may be interpolated)
%     peakdraw, peak value in the figure (may be interpolated)
%     
% 

if nargin<8  ;   figsw=1; end
if nargin<7  ;   intpsw=1; end
if nargin<6  ;   logsw=1; end
if nargin<5  ;   widthlevel=1/sqrt(2); end
if nargin<4  ;   xpeak='measured'; end
if nargin<3  ;   normode='as is'; end

if length(xaxis)~=length(profilelin)
    error('unequal length');
end

dx=xaxis(2)-xaxis(1);

%pk0
if strcmpi(xpeak, 'measured')
    [pk0,pk0idx]=max(profilelin);
else
    validateattributes(xpeak, {'numeric'}, {'real','scalar','nonempty'}, 'profileAnalyzor1d', 'xpeak');
    [~,pkinidx]=min(abs(xpeak-xaxis));
    pkfoundr=0;
    pkfoundl=0;
    for idx1=0:length(profilelin)
        if profilelin(pkinidx+idx1)>=profilelin(pkinidx+idx1-1) && profilelin(pkinidx+idx1)>=profilelin(pkinidx+idx1+1)            
            pk0idxr=pkinidx+idx1;
            pk0r=profilelin(pk0idxr);
            pkfoundr=1;
        end
        if profilelin(pkinidx-idx1)>=profilelin(pkinidx-idx1-1) && profilelin(pkinidx-idx1)>=profilelin(pkinidx-idx1+1)            
            pk0idxl=pkinidx-idx1;
            pk0l=profilelin(pk0idxl);
            pkfoundl=1;
        end
        if pkfoundl==1 && pkfoundr==1
            if pk0r>pk0l
                pk0=pk0r;
                pk0idx=pk0idxr;
            else
                pk0=pk0l;
                pk0idx=pk0idxl;
            end
            break
        else
            if pkfoundl==1
                pk0=pk0l;
                pk0idx=pk0idxl;
                break
            else
                if pkfoundr==1
                    pk0=pk0r;
                    pk0idx=pk0idxr;
                    break
                end
            end
        end
    end
end

% intpsw
pkadj=3;
respratio=10;
if 1==intpsw
%     if profilelin(pk0idx-1)>=profilelin(pk0idx+1)
%         pk0around=profilelin(pk0idx-2:pk0idx+1);
%         x0around=xaxis(pk0idx-2:pk0idx+1);
%     else
%         pk0around=profilelin(pk0idx-1:pk0idx+2);
%         x0around=xaxis(pk0idx-1:pk0idx+2);
%     end
%     a1b1=[-1 -1]/([x0around(1:2) ; pk0around(1:2)]);
%     a2b2=[-1 -1]/([x0around(3:4) ; pk0around(3:4)]);
%     x1pk1=([a1b1;a2b2])\[-1; -1];
% 
%     if x1pk1(2)>=pk0
%         pk=x1pk1(2);
%         pkx=x1pk1(1);
%     else
%         pk=pk0;
%         pkx=xaxis(pk0idx);
%     end

%     pk0around=profilelin(pk0idx-pkadj:pk0idx+pkadj);
%     if (max(pk0around)-min(pk0around))/mean(pk0around)>0.01
%         x0aroundleft=xaxis(pk0idx-pkadj);
%         pk0aroundresp=resample(pk0around,respratio,1);
%         [pk,pkidxlocal]=max(pk0aroundresp);
%         pkx=x0aroundleft+(dx)/respratio*(pkidxlocal-1);
%     else
%         pk=pk0;
%         pkx=xaxis(pk0idx);
%     end
    
    pk0around=profilelin(pk0idx-pkadj:pk0idx+pkadj);
    x0around=xaxis(pk0idx-pkadj:pk0idx+pkadj);
    x0aroundresp=x0around(1):dx/respratio:x0around(end);
    pk0aroundresp=interp1(x0around, pk0around, x0aroundresp, 'spline');
    [pk,pkidxlocal]=max(pk0aroundresp);
    pkx=x0aroundresp(pkidxlocal);
else
    pk=pk0;
    pkx=xaxis(pk0idx);
end


% normode
if strcmpi(normode, 'as is')
    refvalue=1;
else
    if strcmpi(normode, 'max norm')
        refvalue=pk;
    else
        if strcmpi(normode, 'avg norm')
            refvalue=mean(profilelin);
        else
            if strcmpi(normode, 'gain norm')
                theta1=linspace(0,pi,length(profilelin));
                theta1=reshape(theta1,size(profilelin));
                refvalue=sqrt(1/2*sum( (abs(profilelin).^2).*sin(theta1)*pi/length(profilelin) ));
            else
                validateattributes(normode, {'numeric'}, {'real','scalar','nonempty'}, 'profileAnalyzor1d', 'normode');
                refvalue=normode;
            end            
        end
    end
end

% widthheight
wh=pk/refvalue*widthlevel;
data1=profilelin/refvalue-wh;

flagl=0;
flagr=0;
for idx2=0:length(data1)
    if 0==flagl
        if data1(pk0idx-idx2)>=0 && data1(pk0idx-idx2-1)<=0
            if data1(pk0idx-idx2)~=0 && data1(pk0idx-idx2-1)~=0
                xl=xaxis(pk0idx-idx2-1)-dx*data1(pk0idx-idx2-1) / (data1(pk0idx-idx2)-data1(pk0idx-idx2-1));
            else
                if data1(pk0idx-idx2)==0 && data1(pk0idx-idx2-1)==0
                    xl=xaxis(pk0idx-idx2-1)+dx/2;
                else
                    if data1(pk0idx-idx2-1)==0
                        xl=xaxis(pk0idx-idx2-1);
                    else
                        xl=xaxis(pk0idx-idx2);
                    end
                end
            end
            flagl=1;
        end        
    end
    
    if 0==flagr
        if data1(pk0idx+idx2)>=0 && data1(pk0idx+idx2+1)<=0
            if data1(pk0idx+idx2)~=0 && data1(pk0idx+idx2+1)~=0
                xr=xaxis(pk0idx+idx2+1)+dx*data1(pk0idx+idx2+1) / (data1(pk0idx+idx2)-data1(pk0idx+idx2+1));
            else
                if data1(pk0idx+idx2)==0 && data1(pk0idx+idx2+1)==0
                    xr=xaxis(pk0idx+idx2+1)-dx/2;
                else
                    if data1(pk0idx+idx2+1)==0
                        xr=xaxis(pk0idx+idx2+1);
                    else
                        xr=xaxis(pk0idx+idx2);
                    end
                end
            end
            flagr=1;
        end        
    end
    
    if 0~=flagl && 0~=flagr
        break
    end
end 

xwidthdraw=xr-xl;
xpeakdraw=pkx;


if 1==logsw
    profiledraw=20*log10(abs(profilelin)/refvalue);
    peakdraw=20*log10(pk/refvalue);
    whdraw=20*log10(wh);
    whdrawh=20*log10(wh)+3;
    whdrawl=20*log10(wh)-3;
else
    profiledraw=abs(profilelin)/refvalue;
    peakdraw=(pk/refvalue);
    whdraw=wh;
    whdrawh=1.414*wh;
    whdrawl=0.707*wh;
end


if figsw>0
    validateattributes(figsw, {'numeric'}, {'real','integer','scalar','nonempty'}, 'profileAnalyzor1d', 'normode');
    figure(figsw);
    plot(xaxis,profiledraw);hold on
    line([xl xl],[whdrawl whdrawh],'LineStyle','--');
    line([xr xr],[whdrawl whdrawh],'LineStyle','--');
    line([xl xr],[whdraw whdraw],'LineStyle','--');
    text(xpeakdraw,peakdraw,['peak: ' num2str(peakdraw)]);
    text(xr,whdraw,[{['width: ' num2str(xwidthdraw)];[ 'level: ' num2str(whdraw)]}]);
end
    

end

