
clear all

w=0:0.01:1
L=factorial(10)*(w.^7).*(1-w).^3/(factorial(7)*factorial(3));
plot(w,L)