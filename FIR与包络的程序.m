clear; 
figure;
sp=3;
point=4000;

%变量定义
ts=1e-6;
t=0:ts:point*ts;

fc1=2e4;
ac1=1;

fm1=2e3;
am1=0.5;

SNR=20;

pm1=3.14;

%信号、载波、噪声 
m=am1*cos(2*pi*fm1*t);
subplot(sp,2,1);
plot(t,m);title('基带');
subplot(sp,2,2);
fft_plot_part(m,ts,4096,1,45000 );

ci=cos(2*pi*fc1*t);
cq=sin(2*pi*fc1*t);

%pm=ci-pm1*m.*cq;
pm=ci.*cos(pm1*m)-sin(pm1*m).*cq;
%pm=cos(2*pi*fc1*t+pm1*m);
subplot(sp,2,3);
plot(t,pm);title('已调');axis([0 point*ts -1.2 1.2]);
subplot(sp,2,4);
fft_plot_part(pm,ts,4096,1,45000 );

pmn=awgn(pm,SNR); 
subplot(sp,2,5);
plot(t,pm);title('加噪声');axis([0 point*ts -1.2 1.2]);
subplot(sp,2,6);
fft_plot_part(pm,ts,4096,1,45000 );

figure;
sp=5;


% 带通滤波
fsamp = 1e6;
fcuts = [45000 48000];
mags = [1 0];
devs = [0.05 0.01];
[n,Wn,beta,ftype] = kaiserord(fcuts,mags,devs,fsamp);
n = n + rem(n,2);
hh = fir1(n,Wn,ftype,kaiser(n+1,beta),'noscale');
% [H,f] = freqz(hh,1,1024,fsamp);
% plot(f,abs(H)), grid on
pmn_bfp = fftfilt(hh,pmn); 
subplot(sp,2,1)
plot(t,pmn_bfp);title('BPF');
subplot(sp,2,2);
fft_plot_part(pmn_bfp,ts,4096,1,45000 );

% 微分器
for i=1:length(t)-1                     
    pmn_bfp_diff(i)=(pmn_bfp(i+1)-pmn_bfp(i))/ts/100000; 
end 
pmn_bfp_diff(length(t))=pmn_bfp(length(t));
subplot(sp,2,3);
plot(t,pmn_bfp_diff);title('DIFF');
subplot(sp,2,4);
fft_plot_part(pmn_bfp_diff,ts,4096,1,45000 );

% 包络检波
pmn_bfp_diff_dio = abs(hilbert(pmn_bfp_diff));      %hilbert(x)=x+j^x→复形式,即将cos变为exp(jxx)的形式;
subplot(sp,2,5);
plot(t,pmn_bfp_diff_dio);title('ENEVLOP');
subplot(sp,2,6);
fft_plot_part(pmn_bfp_diff_dio,ts,4096,1,45000 );
% 高通滤波（隔直）
fsamp = 1/ts;
fcuts = [100 1700];
mags = [0 1];
devs = [0.05 0.01];
[n,Wn,beta,ftype] = kaiserord(fcuts,mags,devs,fsamp);
n = n + rem(n,2);
hh3 = fir1(n,Wn,ftype,kaiser(n+1,beta),'noscale');
% [H,f] = freqz(hh,1,1024,fsamp);
% plot(f,abs(H)), grid on
pmn_bfp_diff_dio_gz= fftfilt(hh3,pmn_bfp_diff_dio); 
subplot(sp,2,7);
plot(t,pmn_bfp_diff_dio_gz);title('隔直（HPF）');
subplot(sp,2,8)
fft_plot_part(pmn_bfp_diff_dio_gz,ts,4096,1,45000 );

% 积分器 
pmn_bfp_diff_dio_gz_int=cumsum(pmn_bfp_diff_dio_gz)/100;
pmn_bfp_diff_dio_gz_int_gz=fftfilt(hh3,pmn_bfp_diff_dio_gz_int); 
subplot(sp,2,9);
plot(t,pmn_bfp_diff_dio_gz_int_gz);title('积分 & 隔直（HPF）');
subplot(sp,2,10);
fft_plot_part(pmn_bfp_diff_dio_gz_int_gz,ts,4096,1,45000 );

