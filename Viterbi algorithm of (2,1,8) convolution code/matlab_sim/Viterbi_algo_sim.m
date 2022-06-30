
clear all
clc
bits_num=10^4;
u=rand(1,bits_num)>0.5;
uu=u*2-1;
SNR_db=1:7;
SNR=10.^(SNR_db/10);
noise_pow=1./SNR;

for i=1:length(SNR)
    i
    w=(noise_pow(i))^(1/2)*randn(1,length(u));
    r1=uu+w(1:length(uu));
    out1=r1>0;
    BER_uncoded(i)=sum(out1~=u)/bits_num;
    
    for k=1:10
        v=Encoder_218(u(k:k+bits_num/10-1));
        vv=v
        
    end
    %BER_218(i)=sum(out2~=u)/bits_num;

end
figure(2)
semilogy(SNR_db,BER_uncoded,'-*');
hold on
semilogy(SNR_db,BER_218,'-o');
