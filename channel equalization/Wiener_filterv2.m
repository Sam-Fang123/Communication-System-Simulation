
clear all
W=3.1;
noise_power=0.001;

n = 1:3;
h1 = 0.5*(1+cos((2*pi/W)*(n-2)));    
h = [zeros(1) h1];
h=h.';
N=100000;
M=11;
x=(rand(N,1)>0.5)*2-1;

H=[h.' zeros(1,M-1)];
for i=2:M
    H(i,:)=circshift(H(i-1,:),1);
end

u=conv(h,x);
u=u+sqrt(noise_power)*randn(length(u),1);

R=H*H.'+noise_power*eye(M);
e=[1 zeros(1,13)].';

for delay=0:13
    p=H*e;
    e=circshift(e,1);
    w=R\p;
    
    h_eq=conv(w,h);
    xx=conv(u,w);
    xxx=xx(delay+1:delay+N);
    
    MSE(delay+1)=mean((xxx-x).^2);
    %MSE(delay+1)=var(xxx-x);
    %MSE(delay+1)=(xxx(1)-x(1)).^2;
    
    if MSE(delay+1)==min(MSE)
        w_opt=w;
        hh_opt=h_eq;
        p_opt=p;
        e_opt=e;
        delay_opt=delay;
    end
end

figure(1)
stem(0:length(h)-1,h);
axis([0, 5,-inf, inf]);
title('Channel impulse response, W=3.1');
xticks(0:5);
xlabel('n');ylabel('h[n]');

figure(2)
stem(0:length(w_opt)-1,w_opt)
title('Impulse response of optimum FIR equalizer w0');
xticks(0:length(w_opt)-1);
xlabel('n');ylabel('w[n]');

figure(3)
stem(0:length(hh_opt)-1,hh_opt)
title('Equalized channel (Convolution of w0 and h)')
xticks(0:length(hh_opt)-1);
xlabel('n');ylabel('hh[n]');

figure(4)
stem(0:length(MSE)-1,MSE);
title('MSE with different delay');
xticks(0:length(MSE)-1);
xlabel('delay');
w_opt=w_opt.'
min(MSE)