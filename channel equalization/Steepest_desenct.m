
clear all
a=[-0.195;0.95];
Jmin=0.0965;
sigma_u=(1+a(2))*Jmin/(1-a(2))/((1+a(2))^2-a(1)^2);
r0 = sigma_u;
r1 = (-a(1)/(1+a(2)))*sigma_u;
R=[r0 r1;r1 r0];
[V D]=eig(R)