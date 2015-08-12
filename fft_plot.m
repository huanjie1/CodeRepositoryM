function [ fftresult1, f] = fft_plot( sequence_TIME, timeinternal, fftpoint, modenum )
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
%   ����˵����fft�����  ����ʱ�����У�����ʱ������fft������ģʽ����
%   modenum˵����
%       0��log fig
%       1��linear fig
%       2: without fig
%   �򻯷�����plot(linspace(-fs/2,fs/2,501),abs(fftshift(fft(sigf))));title('�����źŵ�Ƶ��');
if nargin<4, modenum=1; end
if nargin<3, fftpoint=length(sequence_TIME);end

sequence_TIME(isnan(sequence_TIME))=0;
% f=(0:fftpoint-1)*(1/fftpoint)*(1/timeinternal)-0.5/timeinternal;
w=fftshift(linspace(0,2*pi*(fftpoint-1)/fftpoint,fftpoint));
w(w>=pi)=w(w>=pi)-2*pi;
f=w/2/pi/timeinternal;
fftresult0=fft(sequence_TIME,fftpoint);
fftresult1=fftshift(fftresult0);

if fftpoint<=size(sequence_TIME);
    error('fftpoint should be more than the size of sequence_TIME');
end;

if modenum==2
    return;
end;

if modenum==0
    fftresult=fftshift(20*log10(abs(fftresult0)));
else
    fftresult=fftshift(abs(fftresult0));
end;


figure;
plot(f,fftresult);
title('Freq Spectum');
xlabel('Freq/Hz');
if modenum==0
    ylabel('Mag/dB');
else
    ylabel('Mag');
end;

% fftarg=fftshift(angle(fftresult0));
% figure;
% plot(f,fftarg);
% title('Freq Spectum');
% xlabel('Freq/Hz');
end
