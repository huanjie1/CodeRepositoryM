%%%%%%%%%%%GIF
    a1=figure(ii+99999);%ii为循环变量
    set(a1,'color','white');
    plot(xxx99,yyy99);
    ylim([-ymin99 ymax99]);%选取绘图区的并集
    text(xx999,yy999,...
        ['sweep = ',  num2str(sweep(ii))],...
        'VerticalAlignment','bottom',...
        'HorizontalAlignment','left');%扫描参数的说明，位置自行设定
    frame=getframe(ii+99999);
    im=frame2im(frame);%制作gif文件，图像必须是index索引图像
    close (ii+99999)
    [I,map]=rgb2ind(im,256);
    if ii==1;
        imwrite(I,map,'filename.gif','gif','Loopcount',inf,...
            'DelayTime',0.1);
    else
        imwrite(I,map,'filename.gif','gif','WriteMode','append',...
            'DelayTime',0.15);%layTime用于设置gif文件的播放快慢
    end
%%%%%%%GIF