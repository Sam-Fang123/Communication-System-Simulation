
clear all
W=[2.9 3.3 3.5];
step_size=0.025;
noise_power=0.001;
M = 11;
N = 2001;
K=200;
delay = 7;
J = zeros(length(step_size),N);

for s=1:length(W)
    n = 1:3;
    h1 = 0.5*(1+cos((2*pi/W(s))*(n-2)));    
    h = [zeros(1) h1];
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
                w=w+step_size*e*u2;
                JJ(i,n)=abs(e)^2;
            end
        end
    end
    
    J(s,:)=sum(JJ,1)/K;
end

semilogy(0:N-1,J);
%legend('step size=0.075','step size=0.025','step size=0.0075')
legend('eigenvalue spread=6.0782','eigenvalue spread=21.7132','eigenvalue spread=48.8216')
xlabel('Number of iterations')
ylabel('Ensemble-average-square error')
axis([0 N-1 10^-3 10^1]);

H=[h zeros(1,M-1)];
for jj=2:M
    H(jj,:)=circshift(H(jj-1,:),1);
end
R=H*H.'+noise_power*eye(M);
    
[V D] = eig(R);
eigen_v = diag(D);
eigen_spread = max(eigen_v)/min(eigen_v);
