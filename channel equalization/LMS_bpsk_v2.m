clear all
W=3.1;
SNR_db=1:14;
SNR_lin=10.^(SNR_db/10); % SNR=symbol power=1/noise_power
noise_pow=1./SNR_lin;
step_size=[0.075 0.025 0.0075];
n = 1:3;
h1 = 0.5*(1+cos((2*pi/W)*(n-2)));    
h = [zeros(1) h1];
N=10^7;
M=11;
delay=7;
BER=zeros(3,length(noise_pow));

for s=1:length(step_size)
    for j=1:length(noise_pow)
        x=(rand(1,N)>0.5)*2-1;
        u=conv(x,h);
        u=u+sqrt(noise_pow(j))*randn(1,length(u));
        u=u(1:end-3);
        w=zeros(1,M);
        for n=1:N
             if n<M
                  u2=[u(n:-1:1) zeros(1,M-n)];
             else
                 u2=u(n:-1:n-(M-1));
             end
             y=w*u2';
             if n>delay
                 e=x(n-delay)-y;
                 w=w+step_size(s)*e*u2;
                 Y=(y>0)*2-1;
                 if Y~=x(n-delay)
                     BER(s,j)=BER(s,j)+1;
                 end
             end
         end
    end
end
    
semilogy(SNR_db,BER/N);
            
