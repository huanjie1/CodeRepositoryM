function [ outputsig ] = realenv( inputsig, order, paras, figsw )
%     realenv: extract the real envelop of a real signal using local maximum
%        and interpolation
%     input arguments:   
%     inputsig (row vector)
%     order (integer, optional): number of times of maximum-interpolation process 
%     parameters of the anti-platform process (2-element vector, optional):
%         para1(1) (integer): index of the maximum-interpolation process when starting anti-platform process
%         para1(2) (double): additional slope
%     figure switch (1:on, 0:off)

if nargin<4
    figsw=0;
end

if nargin<3
    paras=[order+1 0];
end

t=1:length(inputsig);

if figsw>0
    plot(t,inputsig);hold on
end

max0=inputsig;
tmax0=t;
for idx=1:order
    maxposition1=[true diff(sign(diff(max0)))==-2 true] ...
                    | [true diff(sign(diff(max0)))==-1 true];    
    if idx>=paras(1)
        maxposition1=maxposition1 ...
                   | [true diff(sign(diff(max0)-paras(2)))==-2 true]...
                   | [true diff(sign(diff(max0)+paras(2)))==-2 true];
    end   
    
    max1=max0(maxposition1);
    tmax1=tmax0(maxposition1);
    aa1=interp1(tmax1,max1,t,'pchip');
    
    if figsw>0
        plot(t,aa1); hold on
    end
    
    max0=max1;
    tmax0=tmax1;
    
end

outputsig=aa1;

end

