
% This file is used to simulate convolution code
clear all
clc
bits_num=10^7;
u=rand(1,bits_num)>0.5;
uu=u*2-1;
SNR_db=0:14;
SNR=10.^(SNR_db/10);
noise_pow=1./SNR;
block_length=1000;
out1=zeros(1,bits_num);
out2=zeros(1,bits_num);
for i=1:length(SNR)
    i
    w=(noise_pow(i))^(1/2)*randn(1,length(u));
    r1=uu+w(1:length(uu));
    out1=r1>0;
    BER_uncoded(i)=sum(out1~=u)/bits_num;

end
semilogy(SNR_db,BER_uncoded,'-o');
hold on
semilogy(SNR_db,qfunc(sqrt(SNR)),'-+');
grid minor
grid on
