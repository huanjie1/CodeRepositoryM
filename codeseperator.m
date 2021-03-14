clear
finname='radarcode.m';
fidin=fopen(finname);

while ~feof(fidin)
    tline=fgetl(fidin);
    if strcmp(tline,'%%%123456abcd%%%')
        foutname0=fgetl(fidin);
        foutname=foutname0(2:end);
        fidout=fopen(foutname,'w');
        while 1
            tline=fgetl(fidin);% 从文件读行
            if strcmp(tline,'%%%endoffile%%%')
                fclose(fidout);
                break
            else
                fprintf(fidout,'%s\n',tline);
            end
        end
    end
end

fclose(fidin);

