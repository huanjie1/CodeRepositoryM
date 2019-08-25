function [sigout] = devicenoise(sigin,fs,gain,para1,modein,R)
% 在时域上模拟器件的增益与白噪声特性
% 参数说明：
%     输入：输入信号序列（实数或复数行向量），采样率，增益，参数，模式，阻抗（默认50欧）
%     输出：输入信号序列（实数或复数行向量）
% 模式说明：（参数含义）
%     'f'：双口器件的噪声系数（dB）
%     'te'：双口器件的等效噪声温度（K）
%     'nl'：单口器件的噪声电平（dBm/Hz）
%     'nlt'：单口器件的等效噪声温度（K）
% 模式说明中添加'c'代表强制以复数模式调用
% 'nl'模式下，复数模式添加-174（举例）噪声，则双边谱的噪声为-174
%             实数模式添加-174（举例）噪声，则双边谱的噪声为-180，单边谱为-174
%             复数的实部和虚部分辨以实数模式添加-174（举例）噪声，则重新叠加后的复信号双边谱的噪声为-177(对应IQ的3dB增益？)
            


% % 示例程序
% % clear
% % 
% % tw=4e-6;
% % period=4e-6;
% % bw=0e9;
% % fc=22.0000000e9;
% % 
% % fs=100e9; 
% % ts=1/fs;
% % t=-period/2:ts:(period/2-ts);
% % tdelay=10e-9;
% % 
% % kk=bw/tw;
% % 
% % saimt=real(rectpuls((t)/tw).*exp(1j*(2*pi*fc*t+pi*kk*t.^2)));
% % awgnl=-174;
% % txloss=-3;
% % 
% % noiseavgnum=100;
% % sawgfa=0;
% % stxfa=0;
% % 
% % for noiseidx=1:noiseavgnum
% % 
% %     sawgt=devicenoise(saimt,0,awgnl,'nl');
% %     
% %     [ sawgf]=fft_plot( sawgt, ts,length(sawgt),2);
% %     sawgfa=sawgfa+abs(sawgf).^2;
% %     
% %     stxt=devicenoise(sawgt,txloss,-txloss,'f');
% % %     stxt=devicenoise(sawgt,txloss,-174,'nl');
% % 
% %     [ stxf]=fft_plot( stxt, ts,length(stxt),2);
% %     stxfa=stxfa+abs(stxf).^2;
% %     
% % end
% % sawgfa=sqrt(sawgfa/noiseavgnum);
% % stxfa=sqrt(stxfa/noiseavgnum);
% % 
% % fft_plot( sawgfa, ts, length(sawgt), 5, 123);
% % fft_plot( stxfa, ts, length(stxt), 5, 123);



if nargin<6
    R=50;
end

t0=290;
k=1.380649e-23;
kt0=k*t0;
gainlin=10^(gain/10);
sl=length(sigin);


mode=modein;
mode(strfind(mode,'c'))=[];
switch mode
    case 'f'
        if para1<0
            error('bad noise figure');
        end
        flin=10^(para1/10);
        noisepsd=(flin-1)*kt0*gainlin;
        
    case 'te'
        if para1<0
            error('bad equivalent noise temperature');
        end
        noisepsd=k*para1*gainlin;
        
    case 'nl'
        noisepsd=10^(para1/10)/1000;
        
    case 'nlt'
        noisepsd=k*para1;
end

% noisepsd_digital = noisepsd_analog*rbw = noisepsd_analog*(fs/nl)
% noisepsd = noisepsd_analog
% noiseamp = noisepsd_analog*B*R =  = noisepsd_digital/(fs/nl)*fs*R

if isreal(sigin) && ~contains(modein,'c')
    noiseamp=sqrt(noisepsd*fs/2*R);% sl/2--psd: effective for sigle sideband
    sigout=sigin*sqrt(gainlin)+noiseamp*randn(1,sl);
else
    noiseamp=sqrt(noisepsd*fs*R);% sl--psd: effective for double sideband
    sigout=sigin*sqrt(gainlin)+noiseamp*randn(1,sl)+1j*noiseamp*randn(1,sl);
end



end

