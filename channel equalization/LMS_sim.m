
clear all
W=3.1;
%W=[2.9 3.3 3.5]
step_size=[0.075 0.025 0.0075];
%step_size=0.025

noise_power=0.001;
M = 11;
N = 3001;
K=200;
delay = 7;
J = zeros(length(step_size),N);
w_LMS=zeros(length(step_size),M);
for s=1:length(step_size)
    n = 1:3;
    h1 = 0.5*(1+cos((2*pi/W)*(n-2)));    
    h = [zeros(1) h1];
    ww=zeros(K,M);
    JJ= zeros(K,N);
    H=[h zeros(1,M-1)];
    for jj=2:M
        H(jj,:)=circshift(H(jj-1,:),1);
    end
    R=H*H.'+noise_power*eye(M);

    [V D] = eig(R);
    eigen_v = diag(D);
    eigen_spread = max(eigen_v)/min(eigen_v)
    for i=1:K
        x=(rand(1,N)>0.5)*2-1;
        u=conv(x,h);
        u=u+sqrt(noise_power)*randn(1,length(u));
        u=u(1:end-3);
        w=zeros(1,M);
        for n=1:N
            if n<M
                 u2=[u(n:-1:1) zeros(1,M-n)];
            else
                u2=u(n:-1:n-(M-1));
            end
            y=w*u2';
            if n>delay
                e=x(n-delay)-y;
                w=w+step_size(s)*e*u2;
                JJ(i,n)=abs(e)^2;
            end
        end
        ww(i,:)=w;
    end
    w_LMS(s,:)=ww(1,:);
    J(s,:)=sum(JJ,1)/K;
end
figure(1)
semilogy(0:N-1,J);
legend('step size=0.075','step size=0.025','step size=0.0075')
title('Eigenvlaue spread=11.1238 with different step size')
%title('Step size=0.025 with different eigenvalue spread')
%legend('eigenvalue spread=6.0782','eigenvalue spread=21.7132','eigenvalue spread=46.8216')
xlabel('Number of iterations')
ylabel('Ensemble-average-square error')
axis([0 N-1 10^-3 10^1]);

figure(2)
subplot(3,1,1)
stem(0:length(conv(w_LMS(1,:),h))-1,conv(w_LMS(1,:),h));
title('Equalized channel, step size=0.075');
subplot(3,1,2)
stem(0:length(conv(w_LMS(2,:),h))-1,conv(w_LMS(2,:),h));
title('Equalized channel, step size=0.025');
subplot(3,1,3)
stem(0:length(conv(w_LMS(3,:),h))-1,conv(w_LMS(3,:),h));
title('Equalized channel, step size=0.0075');
