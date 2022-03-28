
clear all

w=0:0.01:1;
L=factorial(10)*(w.^6).*(1-w).^4/(factorial(6)*factorial(4));
figure(1)
plot(w,L)
xticks([0:0.1:1])
xlabel('Parameter w')
ylabel('Likelihood L(w|n=10,y=6)')
grid on

figure(2)
y=0:10;
f=factorial(10)*(0.6.^y).*(0.4.^(10-y))./factorial(y)./factorial(10-y);
bar(y,f);
xlabel('Data y')
ylabel('f(y|n=10,w=0.6)')
