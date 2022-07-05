clear all

bits_num=10^7;
u=rand(1,bits_num)>0.5;
block_length=1000;
fid = fopen('b.txt','wt');
B=block_length;
for i=1:bits_num
    fprintf(fid,'%g',u(i));
end
fclose(fid);