
% This file is used to simulate convolution code
clear all
fid2= fopen('v.txt');
v = fgetl(fid2);
fclose(fid2);
vv=zeros(1,length(v));
for i=1:length(v)
    if v(i)=='0'
       vv(i)=0;
    else
        vv(i)=1;
    end
end
SNR_db=3;
SNR_lin=10.^(SNR_db/10); % SNR=symbol power=1/noise_power
noise_pow=1./SNR_lin;
r=(vv*2-1)+sqrt(noise_pow)*randn(1,length(vv));
rr=r>0;

