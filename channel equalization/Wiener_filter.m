
clear all
W=3.2;
noise_power=0.001;
M=11;
N=1000;

n = 1:3;
h1 = 0.5*(1+cos((2*pi/W)*(n-2)));    
h = [zeros(1) h1];
h=h.';
x=(rand(N,1)>0.5)*2-1;
xx=zeros(1,length(x));

H=zeros(M);
H(1,:)=[h(4) zeros(1,M-1)];
H(2,:)=[h(3) h(4) zeros(1,M-2)];
H(3,:)=[h(2) h(3) h(4) zeros(1,M-3)];
for i=4:M
    H(i,:)=circshift(H(i-1,:),1);
end

u=conv(h,x);
u=u(4:end)+sqrt(noise_power)*randn(length(u(4:end)),1);
R=H*H.'+noise_power*eye(M);
e=[1 zeros(1,11-1)].';

for delay=3:M+3-1
    p=H*e;
    e=circshift(e,1);
    w=R\p;
    
    hh=conv(w,h);
    figure(delay)
    stem(0:length(hh)-1,hh);
    xx=conv(x,hh);
    xxx=xx(delay+1:delay+N);
    MSE(delay-2)=mean((xxx-x).^2)
end
figure(14)
stem(3:M+3-1,MSE)

