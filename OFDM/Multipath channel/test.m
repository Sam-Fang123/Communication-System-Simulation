
clear
t=1:64;
h=[1,-0.5];
H=fft(h,64);
Y=ones(1,64);
y=ifft(Y);
y=[y(63:64) y];
z=conv(h,y);
Z=fft(z(3:66));

figure(1)
stem(t,Z)
figure(2)
stem(t,H)