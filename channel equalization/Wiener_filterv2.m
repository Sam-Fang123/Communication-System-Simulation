
clear all
W=3.5;
noise_power=0.001;

n = 1:3;
h1 = 0.5*(1+cos((2*pi/W)*(n-2)));    
h = [zeros(1) h1];
h=h.';

M=11;
x=(rand(M+3,1)>0.5)*2-1;

H=[h.' zeros(1,M-1)];
for i=2:M
    H(i,:)=circshift(H(i-1,:),1);
end

u=conv(h,x);
u=u(4:end-3)+sqrt(noise_power)*randn(length(u(4:end-3)),1);
R=H*H.'+noise_power*eye(M);
e=[1 zeros(1,length(x)-1)].';

for delay=0:length(x)-1
    p=H*e;
    e=circshift(e,1);
    w=R\p;
    
    hh=conv(w,h);
    xx=conv(x,hh);
    xxx=xx(delay+1:delay+length(x));
    
    MSE(delay+1)=mean((xxx-x).^2);
    %MSE(delay+1)=var(xxx-x);
    if MSE(delay+1)==min(MSE)
        w_opt=w;
        hh_opt=hh;
    end
end

figure(1)
stem(0:length(h)-1,h);
axis([0, 5,-inf, inf]);
title('Channel impulse response');
xlabel('n');ylabel('h[n]');

figure(2)
stem(0:length(w_opt)-1,w_opt)
title('w_optimum');
xlabel('n');ylabel('w[n]');

figure(3)
stem(0:length(hh_opt)-1,hh_opt)
title('Equalized channel')
xlabel('n');ylabel('hh[n]');

figure(4)
stem(0:length(MSE)-1,MSE);
title('MSE');
xlabel('delay');
