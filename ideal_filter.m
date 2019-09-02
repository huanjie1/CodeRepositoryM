function [ outputsig ] = ideal_filter( inputsig, ts, ftype, magpara, delaypara, phasepara, fig )
%   ideal_filter using FFT and IFFT
%   ftypes(string)   magpara(freq/Hz)
%       'lp'              1e8  (one parameter)
%       'hp'              1e8   (one parameter)
%       'bp'              [1e8, 2e8] (two parameters)
%       'cbp'              [1e8, 2e8, order] (three parameters) for complex signal (non-even symmetry response)
%                                 order<60, sqrt(2).^(-a.^order); order>=60, ideal filter
%       'bs'              [1e8, 2e8] (two parameters)
%     'define'            vector with the same length with inputsig
%                               attention1: if this mode is activated,  inputsig should be the spetrum instead of the time domain waveform
%                                    in which [ fftresult1, faxis]=fft_plot( sequence_TIME, timeinternal)
%                                    should be invoked ahead of  ideal_filter(fftresult1,timeinterna,'define',mask). 
%                                    The freq axis of the defined freq mask should be faxis.
%                               attention2: if this function is used upon a real
%                                    input, magpara should be even symmetrical

%    fig:         draw figures (1) or not (0)   
%    delaypara:   delay(s) 
%    phasepara:   phaseshift(degree)
% 
% % % example1:
% % fs=40e9;
% % ts=1/fs;
% % t=0:ts:ts*8191;
% % sigin=square(2*pi*0.25e9*t,5);
% % plot(t,sigin)
% % ideal_filter(sigin, ts, 'bp',[1e9, 3e9], -1e-9, 0, 1 );
% 
% % % example2:
% % fs=40e9;
% % ts=1/fs;
% % t=0:ts:ts*8191;
% % sigin=square(2*pi*0.25e9*t,5);
% % plot(t,sigin)
% % [ fftresult1, faxis]=fft_plot( sigin, ts);
% % ideal_filter( fftresult1, ts, 'define',exp(-(faxis/1e9).^2), 0, 0, 1 );

if nargin<7, fig=0; end
if nargin<6, phasepara=0; end
if nargin<5, delaypara=0; end

inlength=length(inputsig);

switch ftype
    case {'lp','hp'}
         if length(magpara)~=1
            error('bad magpara');
        end
    case {'bs','bp'}
         if length(magpara)~=2 || magpara(1)>=magpara(2)
            error('bad magpara');
         end        
    case {'cbp'}
         if length(magpara)~=3 || magpara(1)>=magpara(2)
            error('bad magpara');
        end
    case 'define'
        if length(magpara)~=inlength
            error('bad magpara');
        end
    otherwise
        error('bad ftype');
end

if fig>0.5 && 0==strcmp('define', ftype)
    figure;plot(0:ts:ts*(inlength-1),  inputsig);title('input waveform');
end

filtermaskmag=zeros(1,inlength);
[ inputsigfreq0, faxis]=fft_plot(  inputsig, ts, inlength, 2);

if 1==strcmp('define', ftype)
    inputsigfreq=inputsig;
else
    inputsigfreq=inputsigfreq0;
end

if fig>0.5 
    figure;plot(faxis,   abs(inputsigfreq));title('input spetrum');
end
    
switch ftype
    case 'lp'
        filtermaskmag( abs(faxis)<magpara)=1;
    case 'hp'
        filtermaskmag( abs(faxis)>magpara)=1;
    case 'bp'
        filtermaskmag( (abs(faxis)>magpara(1)) & (abs(faxis)<magpara(2)))=1;
    case 'cbp'
        if magpara(3)<60
            filtermaskmag=sqrt(2).^(-( (faxis- (magpara(1)+magpara(2))/2) / ( magpara(2)-magpara(1))*2 ).^magpara(3));
        else
            filtermaskmag( ((faxis)>magpara(1)) & ((faxis)<magpara(2)))=1;
        end
        
    case 'bs'
        filtermaskmag( (abs(faxis)<magpara(1)) | (abs(faxis)>magpara(2)))=1;
    case 'define'
        filtermaskmag=magpara;
    otherwise
        filtermaskmag=0;
end

if fig>0.5 
    figure;plot(faxis,  filtermaskmag);title('Hmag');
end 

filtermaskphase=[-ones(1,fix(inlength/2)),ones(1,inlength-fix(inlength/2))]*phasepara/180*pi...
                                -faxis*delaypara*2*pi;

if fig>0.5 
    figure;plot(faxis,  filtermaskphase);title('Hphase');
end 

outputsigfreq=inputsigfreq.* filtermaskmag.*exp(1i*filtermaskphase);
if fig>0.5 
    figure;plot(faxis,  abs(outputsigfreq));title('output spetrum');
end 
outputsig=ifft(ifftshift(outputsigfreq));
if fig>0.5 
    figure;plot(0:ts:ts*(inlength-1),  outputsig);title('output waveform');
end  



end

