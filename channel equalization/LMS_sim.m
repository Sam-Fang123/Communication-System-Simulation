
clear all
W=3.1;
s_size=[0.025 0.075 0.0075];
noise_power=0.001;
M = 11;
delay = 7;
x=(rand(M+3,1)>0.5)*2-1;
for ii=1:length(W)
    n = 1:3;
    h1 = 0.5*(1+cos((2*pi/W(ii))*(n-2)));    
    h = [zeros(1) h1];
    h=h.';
    H=[h.' zeros(1,M-1)];
    for jj=2:M
        H(jj,:)=circshift(H(jj-1,:),1);
    end
    R=H*H.'+noise_power*eye(M);
    [V D] = eig(R);
    eigen_v = diag(D);
    eigen_spread = max(eigen_v)/min(eigen_v);
    
    u=conv(h,x);
    u=u(4:end-3)+sqrt(noise_power)*randn(length(u(4:end-3)),1);
    w = zeros(M,1);
    for kk=1:length(s_size)
        for zz=1:1500
            h_eq = conv(w,h);
            x_out=conv(x,h_eq);
            x_out=x_out(delay+1:delay+length(x));
            %這裡要改一下 看學長的code似乎是每個每個慢慢比???
            e = x(1)-x_out(1);
            w = w + s_size(kk)*u*e;
            J(zz)=abs(e)^2;
        end
        semilogy(1:1500,J);
        hold on
    end 
end

