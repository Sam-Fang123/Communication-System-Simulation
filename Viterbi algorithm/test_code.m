clear all

a=1:100;

for i=1:100
    fid = fopen('b.txt','wt');
    fprintf(fid,'%g',a(i));
    fclose(fid);
end