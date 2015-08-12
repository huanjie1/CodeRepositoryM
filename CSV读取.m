fid1=fopen('w0015.csv');
data1=textscan(fid1,'%f%f','headerlines',29,'delimiter', ',');
fclose(fid1);
lambda=data1{1}.'*1e-9;amplitude1=data1{2}.';
plot(lambda,amplitude1);hold on;