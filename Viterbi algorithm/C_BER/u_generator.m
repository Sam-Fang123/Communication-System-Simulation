clear all
bits_num=10^7;
u=rand(1,bits_num)>0.5;
i=1;
j=1;
B=1000;
uu=zeros(1,bits_num);
for i=1:bits_num
    if u(i)==0
        uu(i)='0';
    else
        uu(i)='1';
    end
end
fid = fopen('u.txt','wt');
fprintf(fid,'%s',uu);
fclose(fid);
clear all