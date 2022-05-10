clc;clear;close all;
K=200;
N=2000;
M=11;
step=0.025;
W=3.1;

se=zeros(K,N);
mse=zeros(1,N);

h=[1 2 3];
h=(1/2)*(1+cos(2*pi*(h-2)/W));

mmse = zeros(1,8);

for delay= 8;

    for j=1:K
        x=rand(1,N)>0.5;
        x=2*x-1;
        w=zeros(1,M);
        r=zeros(1,N);
        u=zeros(1,M);
        y=zeros(1,N);
        for n=1:N
            if n==1
                r(n)=randn(1,1)*sqrt(0.001);
            elseif n==2
                r(n)=h(1)*x(n-1)+randn(1,1)*sqrt(0.001);
            elseif n==3
                r(n)=h(1)*x(n-1)+h(2)*x(n-2)+randn(1,1)*sqrt(0.001);
            else   
                r(n)=h(1)*x(n-1)+h(2)*x(n-2)+h(3)*x(n-3)+randn(1,1)*sqrt(0.001);
            end
   
  
            if n<M
                u=[r(n:-1:1) zeros(1,M-n)];
            else
                u=r(n:-1:n-(M-1));
            end
   
            y(n)=w*u';
            if n > delay
                e=x(n-delay)-y(n);
                w = w+step*e*u;
                se(j,n)=abs(e)^2;
            end
        end
    end

    for f=1:N
        mse(f)=sum(se(:,f))/K;
    end

    mmse(delay+1) = min(mse(500:2000));
end
%figure(1)
%semilogy(mse);
%grid;
semilogy(1:2000,mse);

%figure(2)
%stem(w);
%grid;

%figure(3)
%xx = conv(w,h);
%stem(xx);grid;

figure(4)
semilogy(0:8,mmse);
grid;
xlabel('delay');
ylabel('Minimum MSE');
title('Minimum MSE versus delay with M=11');