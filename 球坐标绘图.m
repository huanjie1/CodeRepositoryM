clear
thetanum=100;
phinum=200;
theta=linspace(0,pi,thetanum)+eps;
phi=linspace(0,2*pi,phinum)+eps;
[thetam,phim]=meshgrid(theta,phi);

% function
len=0.6; %len=1.25 lambda
% em=(cos(pi*len*cos(thetam))-cos(pi*len))./sin(thetam);
% em=abs(1+exp(1i*2*pi*len*sin(thetam-pi/2)));
em=abs(1+exp(1i*2*pi*len*sin(thetam).*cos(phim)-1i*2*pi*len*sin(pi/6).*cos(pi/4))...
    +exp(1i*2*pi*len*sin(thetam).*sin(phim)-1i*2*pi*len*sin(pi/6).*sin(pi/4))...
+exp(1i*2*pi*len*sin(thetam).*cos(phim)+1i*2*pi*len*sin(thetam).*sin(phim)...
-1i*2*pi*len*sin(pi/6).*cos(pi/4)-1i*2*pi*len*sin(pi/6).*sin(pi/4)));

x=em.*sin(thetam).*cos(phim);
y=em.*sin(thetam).*sin(phim);
z=em.*cos(thetam);
figure;surf(x,y,z,abs(em),'EdgeColor','none');
hold on;


axisnum=200;
thetaaxis=linspace(0,2*pi,axisnum);
axismax=max(max(abs(em)))*1.1;

xxoy=axismax*cos(thetaaxis);
yxoy=axismax*sin(thetaaxis);
zxoy=zeros(1,axisnum);
plot3(xxoy,yxoy,zxoy,'b','linewidth',2);
quiver3(0,0,0,0,0,1.3*axismax,'b','linewidth',2);
text(0,0,1.35*axismax,'{\itz}','FontSize',15,'fontname','Times New Roman');

xyoz=zeros(1,axisnum);
yyoz=axismax*cos(thetaaxis);
zyoz=axismax*sin(thetaaxis);
plot3(xyoz,yyoz,zyoz,'r','linewidth',2);
quiver3(0,0,0,1.3*axismax,0,0,'r','linewidth',2);
text(1.35*axismax,0,0,'{\itx}','FontSize',15,'fontname','Times New Roman');

xzox=axismax*sin(thetaaxis);
yzox=zeros(1,axisnum);
zzox=axismax*cos(thetaaxis);
plot3(xzox,yzox,zzox,'g','linewidth',2);
quiver3(0,0,0,0,1.3*axismax,0,'g','linewidth',2);
text(0,1.35*axismax,0,'{\ity}','FontSize',15,'fontname','Times New Roman');

grid off;axis off;
set(gca,'DataAspectRatio',[1 1 1]);
% view(133,18); % position of eye(az,ei)
quiver3(1*axismax,0,0,0,0.2*axismax,0,'black','linewidth',2);
text(1*axismax,0.2*axismax,0,'{\it\phi}','FontSize',10,'fontname','Times New Roman','HorizontalAlignment','center','VerticalAlignment','middle');
quiver3(0,0,1*axismax,0,0.2*axismax,0,'black','linewidth',2);
text(0,0.2*axismax,1*axismax,'{\it\theta}','FontSize',10,'fontname','Times New Roman','HorizontalAlignment','center','VerticalAlignment','middle');


%slice
thetaslice=90/180*pi;%«–∆¨Œª÷√
[dthetamin,thetaindex]=min(abs(theta-thetaslice));
emthetaslice=abs(em(:,thetaindex));
figure;polar(phi,emthetaslice.');title(['H-plane @ {\it\theta} = ' ,num2str(thetaslice*180/pi), '°„']);

phislice1=45/180*pi;%«–∆¨Œª÷√
[dphimin1,phiindex1]=min(abs(phi-phislice1));
emphislice1=abs(em(phiindex1,:));
figure;polar(theta,emphislice1);title( ['E-plane @ {\it\phi} = ' ,num2str(phislice1*180/pi), '°„']);hold on;
phislice2=mod(phislice1+pi,2*pi);%«–∆¨Œª÷√
[dphimin2,phiindex2]=min(abs(phi-phislice2));
emphislice2=abs(em(phiindex2,:));
fig1=polar(2*pi-theta, emphislice2);hold off;
set(fig1,'color',[0 0.4470 0.7410]);
view(-90,90); 

