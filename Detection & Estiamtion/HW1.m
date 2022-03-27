
clear all

w=0:0.01:1;
L=factorial(10)*(w.^7).*(1-w).^3/(factorial(7)*factorial(3));
figure(1)
plot(w,L)

figure(2)
y=0:10;
f=factorial(10)*(0.2.^y).*(0.8.^(10-y))./factorial(y)./factorial(10-y);
stem(y,f)