
% This file is used to simulate convolution code
clear all
clc
bits_num=10^7;
u=rand(1,bits_num)>0.5;
uu=u*2-1;
SNR_db=1:7;
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
    for k=1:block_length:length(u)
        v=Encoder_216(u(k:k+block_length-1));
        vv=v*2-1;
        r2=vv+(noise_pow(i))^(1/2)*randn(1,length(vv));
        r22=r2>0;
        out2(k:k+block_length-1)=Decoder_216(r22);
        out3(k:k+block_length-1)=Decoder_216_soft(r2);
    
        v2=Encoder_316(u(k:k+block_length-1));
        vv2=v2*2-1;
        r3=vv2+(noise_pow(i))^(1/2)*randn(1,length(vv2));
        r33=r3>0;
        out4(k:k+block_length-1)=Decoder_316(r33);
        out5(k:k+block_length-1)=Decoder_316_soft(r3);
    end
    BER_216(i)=sum(out2~=u)/bits_num;
    BER_316(i)=sum(out4~=u)/bits_num;
    BER_216_soft(i)=sum(out3~=u)/bits_num;
    BER_316_soft(i)=sum(out5~=u)/bits_num;

end
semilogy(SNR_db,BER_uncoded,'linewidth',1.5);
hold on
semilogy(SNR_db,BER_216_soft,'linewidth',1.5);
semilogy(SNR_db,BER_316_soft,'linewidth',1.5);
semilogy(SNR_db,BER_216,'linewidth',1.5);
semilogy(SNR_db,BER_316,'linewidth',1.5);
legend('uncoded','(2,1,6) soft','(3,1,6) soft','(2,1,6) hard','(3,1,6) hard')
xlabel('SNR(dB)');ylabel('BER');
grid minor
grid on
