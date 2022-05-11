clear all
W=3.1;
SNR_db=1:14;
SNR_lin=10.^(SNR_db/10); % SNR=symbol power=1/noise_power
noise_pow=1./SNR_lin;
step_size=[0.075 0.025 0.0075];
n = 1:3;
h1 = 0.5*(1+cos((2*pi/W)*(n-2)));    
h = [zeros(1) h1];
N=3001;
M=11;
K=200;
delay=7;
bit_num=10^7;
xx=(rand(1,bit_num)>0.5)*2-1;
BER=zeros(3,length(noise_pow));
w_LMS=zeros(3,M);
for s=1:length(step_size)
    for j=1:length(noise_pow)
        ww=zeros(K,M);
        for i=1:K
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
                 end
            end
            ww(i,:)=w;
        end
        w_eq=mean(ww,1);
        uu=conv(xx,h);
        uu=uu+sqrt(noise_pow(j))*randn(1,length(uu));
        yy=conv(uu,w_eq);
        Y1=(yy>0)*2-1;
        BER(s,j)=sum(Y1(delay+1:delay+bit_num)~=xx)/bit_num;
    end
    figure(s)
    stem(0:13,conv(w_eq,h))
end
semilogy(SNR_db,BER)
            
