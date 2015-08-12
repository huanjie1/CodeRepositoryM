xstart=0;
xend=100;
d=0.1;

xx=xstart:d:xend;
yy=xx;
plot(xx,zeros(1,length(xx)));ylim([(xstart-xend)/2,(-xstart+xend)/2]);title('为使平滑，点应少');

xxselect=[];ampset=[];i1=1;h=[];
while 1
    [x0,y0,but]=ginput(1);
    if but==1       
        xxselect=[xxselect,x0];
        ampset=[ampset,y0];
        h(i1)=line(x0,y0);
        set(h(i1),'Marker','o');
        i1=i1+1;
    else
        break;
    end
end

yy=interp1(xxselect,ampset,xx,'spline');
figure;plot(xx,yy);%COPY FIGURE至visio，再取消组合

% mout=[xx.', yy.' ];
% fid2=fopen('Awg.txt','w');
% fprintf(fid2,'%.2f\t%.2f\n',mout.');
% fclose(fid2);
