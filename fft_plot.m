function [ fftresult1, f,fftresultshow,fshow] = fft_plot( sequence_TIME, timeinternal, fftpin, modenum, fighandle)
%   fft�������ٷ�װ(�Ѹ��£������Ƶ�ʿ�ֱ�������˲�����H����ȷ�� ʵ����ӦΪʵ��)
%   
% 
%   ��ʱ��.*exp( 1i*2*pi*tao*f);
%   ���任��ifft(ifftshift(yfft),fp);
%   �����˲���
%             fh=ones(1,length(f));
%             fh(f>0.1*max(f) | f<-0.1*max(f))=0; % and :&
%             .*fh;
% 
%   ��/��άʱ�����򣩣�������������shift���ɻ��ã�
%             fftshift(fft(sig,fp,2),2);
%             ifft(ifftshift(sigf,2),fp,2);
% 
%   ����˵����
%         �����fft�������fftshift����Ƶ���ᣬͼ�е�fft�����ͼ�е�Ƶ����
%         ���룺����ʱ�����У�����ʱ������fft������ģʽ���룬figure���������figure���ã�
%   modenum˵����
%       0��log fig
%       1��linear fig
%       2��without fig
%       3��dbm fig��˫���� (�������Ϊ��ѹ����λΪV��50ŷ�迹)
%       4��dbm fig�������� (�������Ϊ��ѹ����λΪV��50ŷ�迹)
%       5��dbm fig��˫���� (sequence_TIMEΪ�����fftshift(fft(.))���Ƶ������fftpinΪ����Ӧʱ�����еĳ��ȣ����ܱ�fftshift(fft(.))�٣���Ϊ���㣩)
%       6��dbm fig�������� (sequence_TIMEΪ�����fftshift(fft(.))���Ƶ������fftpinΪ����Ӧʱ�����еĳ��ȣ����ܱ�fftshift(fft(.))�٣���Ϊ���㣩)
%       7��linear fig��˫���� (sequence_TIMEΪ�����fftshift(fft(.))���Ƶ������fftpinΪ����Ӧʱ�����еĳ��ȣ����ܱ�fftshift(fft(.))�٣���Ϊ���㣩)
%   �򻯷�����plot(linspace(-fs/2,fs/2,501),abs(fftshift(fft(sigf))));title('�����źŵ�Ƶ��');



% %% example:
% clear
% 
% tw=4e-6;
% period=4e-6;
% bw=8e9;
% fc=20.0000001e9;
% 
% 
% fs=100e9; 
% ts=1/fs;
% t=-period/2:ts:(period/2-ts);
% tdelay=1e-9;
% 
% kk=bw/tw;
% 
% signalt0c=rectpuls((t)/tw).*exp(1j*(2*pi*fc*t+pi*kk*t.^2)); 
% 
% noiseavgnum=100;
% signalt0rnoisefpowersum=0;
% signalt1rnoisefpowersum=0;
% zeropadmulti=1;
% for noiseidx=1:noiseavgnum
%     sig0=devicenoise((signalt0c),0,-80,'nl');
%     sig1=devicenoise(sig0,40,290,'te');
%     [signalt0rnoiseftemp] = fft_plot( sig0, ts, length(t)*zeropadmulti, 2);%.*hamming(length(sig0))'
%     [signalt1rnoiseftemp] = fft_plot( sig1, ts, length(t)*zeropadmulti, 2);%real(signalt0c)randn(1,length(t))/sqrt(2)
%     signalt0rnoisefpowersum=signalt0rnoisefpowersum+abs(signalt0rnoiseftemp).^2;
%     signalt1rnoisefpowersum=signalt1rnoisefpowersum+abs(signalt1rnoiseftemp).^2;
% end
% signalt0rnoisef=sqrt(signalt0rnoisefpowersum/noiseavgnum);
% signalt1rnoisef=sqrt(signalt1rnoisefpowersum/noiseavgnum);
% % signalt1rnoisefshow0=(10*log10( (abs(signalt1rnoisef)/length(t)*2) .^2/100 )+30);
% % signalt1rnoisefshow=signalt1rnoisefshow0(floor(length(signalt1rnoisef)/2+1.2):end);
% 
% % plot(t,real(signalt0c));
% %  [ fftresult1, f,fftresultshow,fshow] = fft_plot( real(signalt0c), ts, length(t), 3, 123);
% fft_plot( signalt0rnoisef, ts, length(signalt0rnoisef)/zeropadmulti, 5, 123);
% fft_plot( signalt1rnoisef, ts, length(signalt1rnoisef)/zeropadmulti, 5, 123);




if nargin<5, fighandle=0; end
if nargin<4, modenum=1; end
if nargin<3, fftpin=length(sequence_TIME);end

if modenum<5
    fftpoint=fftpin;
else
    fftpoint=length(sequence_TIME);
end 

if fftpoint<length(sequence_TIME)
    error('fftpoint should be more than the size of sequence_TIME');
end

sequence_TIME(isnan(sequence_TIME))=0;
% f=(0:fftpoint-1)*(1/fftpoint)*(1/timeinternal)-0.5/timeinternal;
w=fftshift(linspace(0,2*pi*(fftpoint-1)/fftpoint,fftpoint));
w(w>=(pi-2*eps))=w(w>=(pi-2*eps))-2*pi;
f=w/2/pi/timeinternal;

if modenum<5
    fftresult1=fftshift(fft(sequence_TIME,fftpoint));
    modenum2=modenum;
    sl=length(sequence_TIME);
else
    fftresult1=sequence_TIME;
    sl=fftpin;
    if 5==modenum
        modenum2=3;
    else
        if 6==modenum
            modenum2=4;
        else
            if 7==modenum
                modenum2=1;
            end
        end
    end
end



switch modenum2
    case 0
        fftresultshow=20*log10(abs(fftresult1));
        fshow=f;
    case 1
        fftresultshow=abs(fftresult1);
        fshow=f;
    case 2
        fftresultshow=fftresult1;
        fshow=f;
        return;
    case 3
        fftresultshow=10*log10( (abs(fftresult1)/sl) .^2/100 )+30;
        fshow=f;
    case 4
        fftresultshow0=10*log10( (abs(fftresult1)/sl*2) .^2/100 )+30;
        fftresultshow=fftresultshow0(floor(fftpoint/2+1.2):end);
        fshow=f(floor(fftpoint/2+1.2):end);
end

if 0==fighandle
    figure;plot(fshow,fftresultshow);
else
    figure(fighandle);plot(fshow,fftresultshow);hold on
end
title('Freq Spectum');xlabel('Freq/Hz');

switch modenum2
    case 0
        ylabel('Mag(dB)');
    case 1
        ylabel('Amp');
    case 3
        ylabel('Mag(dBm)');
    case 4
        ylabel('Mag(dBm)');
end

end

