clear
fnarr = ls('*.m');
foutname='radarcode.m';
fidout=fopen(foutname,'w');

for fidx=1:size(fnarr,1)    
    finname=strtrim(fnarr(fidx,:));
    if strcmp(finname,foutname)
        continue
    end
    fprintf(fidout,'%s\n','%%%123456abcd%%%');
    fprintf(fidout,'%%%s\n',finname);
    fidin=fopen(finname);
    while ~feof(fidin) % 判断是否为文件末尾
        tline=fgetl(fidin);% 从文件读行
        fprintf(fidout,'%s\n',tline); 
    end
    fclose(fidin);
    fprintf(fidout,'%s\n\n\n','%%%endoffile%%%');

end
fclose(fidout);
