
% This file is used to simulate convolution code
clear all
fid= fopen('v_218.txt');
fid2=fopen('v_318.txt');
v = fgetl(fid);
v2 = fgetl(fid2);
fclose(fid2);
fclose(fid);
vv=zeros(1,length(v));
for i=1:length(v)
    if v(i)=='0'
       vv(i)=0;
    else
        vv(i)=1;
    end
end
clear v;
for i=1:length(v2)
    if v2(i)=='0'
       vv2(i)=0;
    else
        vv2(i)=1;
    end
end
clear v2;

SNR_db=0:10;
SNR_lin=10.^(SNR_db/10); % SNR=symbol power=1/noise_power
noise_pow=1./SNR_lin;
r_218=zeros(1,length(vv)*length(SNR_db));
r_318=zeros(1,length(vv2)*length(SNR_db));
j=1;
z=1;
for i=1:length(SNR_db)
    r=(vv*2-1)+sqrt(noise_pow(i))*randn(1,length(vv));
    r2=(vv2*2-1)+sqrt(noise_pow(i))*randn(1,length(vv2));
    rr=r>0;
    rr2=r2>0;
    
    for k=1:length(vv)
        if rr(k)==0
            r_218(j)='0';
        else
            r_218(j)='1';
        end
        j=j+1;
    end
    for k=1:length(vv2)
        if rr2(k)==0
            r_318(z)='0';
        else
            r_318(z)='1';
        end
        z=z+1;
    end
        
    
end
fid2 = fopen('r_218.txt','wt');
fprintf(fid2,'%s',r_218);
fclose(fid2);

fid2 = fopen('r_318.txt','wt');
fprintf(fid2,'%s',r_318);
fclose(fid2);
clear all
