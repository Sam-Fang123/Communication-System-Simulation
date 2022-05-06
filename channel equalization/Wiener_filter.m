
clear all
W=5;
noise_power=0.001;
m=11;
h=[0 (1/2)*(1+cos((2*pi*((1:3)-2))/W)) 0];
h=transpose(h);
x=(rand(m,1)>0.5)*2-1;
u=conv(h,x);
u=u+sqrt(noise_power)*randn(length(u),1);
