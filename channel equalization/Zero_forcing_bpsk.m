
clear all
W=3.1;
SNR_db=1:14;
SNR_lin=10.^(SNR_db/10); % SNR=symbol power=1/noise_power
noise_pow=1./SNR_lin;

n = 1:3;
h1 = 0.5*(1+cos((2*pi/W)*(n-2)));    
h = [zeros(1) h1];
h=h.';
N=10^7;
M=11;
x=(rand(1,N)>0.5)*2-1;
delay=7;
H=[h.' zeros(1,M-1)];
for i=2:M
    H(i,:)=circshift(H(i-1,:),1);
end
e=[0 0 0 0 0 0 0 1 0 0 0 0 0 0].';
H_tr=H.';
H_p_inv=inv(H_tr.'*H_tr)*H_tr.';
w=H_p_inv*e;
for i=1:length(noise_pow)
    u=conv(x,h.');
    u=u+sqrt(noise_pow(i))*randn(1,length((u)));
    y=conv(u,w);
    Y1=(u>0)*2-1;
    Y2=(y>0)*2-1;
    BER_bpsk(i)=sum(Y1(2+1:2+N)~=x)/N;
    BER_ZF(i)=sum(Y2(delay+1:delay+N)~=x)/N;
end
semilogy(SNR_db,BER_bpsk,'-o');
hold on
semilogy(SNR_db,BER_ZF,'-d');