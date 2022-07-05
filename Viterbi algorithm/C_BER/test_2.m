clear all
fid = fopen('u.txt');
fid2 = fopen('u2.txt');
u = fgetl(fid);
fclose(fid);
u2 = fgetl(fid2);
fclose(fid2);
    

