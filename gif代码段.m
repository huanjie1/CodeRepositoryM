%%%%%%%%%%%GIF
    a1=figure(ii+99999);%iiΪѭ������
    set(a1,'color','white');
    plot(xxx99,yyy99);
    ylim([-ymin99 ymax99]);%ѡȡ��ͼ���Ĳ���
    text(xx999,yy999,...
        ['sweep = ',  num2str(sweep(ii))],...
        'VerticalAlignment','bottom',...
        'HorizontalAlignment','left');%ɨ�������˵����λ�������趨
    frame=getframe(ii+99999);
    im=frame2im(frame);%����gif�ļ���ͼ�������index����ͼ��
    close (ii+99999)
    [I,map]=rgb2ind(im,256);
    if ii==1;
        imwrite(I,map,'filename.gif','gif','Loopcount',inf,...
            'DelayTime',0.1);
    else
        imwrite(I,map,'filename.gif','gif','WriteMode','append',...
            'DelayTime',0.15);%layTime��������gif�ļ��Ĳ��ſ���
    end
%%%%%%%GIF