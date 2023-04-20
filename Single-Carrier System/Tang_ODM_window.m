
function [w]=Tang_ODM_window(N,Q,fd)


%F = dftmtx(N)/sqrt(N);
F = fft(eye(N))/sqrt(N);
B_N = [F(:,1:Q/2+1) F(:,end-Q/2+1:end)];
Rho_BN = eye(N)-B_N*pinv(B_N);
I = eye(N);
R_HH = zeros(N,N);
for m = 1:N
    for n = 1:N
        R_HH(m,n) = besselj(0,2*pi*fd*(m-n));
    end
end

X_sum = 0;
for n=1:N
    X_sum = X_sum + diag(Rho_BN.'*I(:,n))*R_HH*diag(conj(Rho_BN.')*I(:,n));
end
X_N = B_N.'*X_sum*conj(B_N);
[V,D] = eig(conj(X_N));
dd = diag(D); 
[m,i] = min(dd);
d_hat = V(:,i);
w = B_N*d_hat;
w = w*sqrt(N/sum(w.^2));
%plot(0:N-1,abs(w))



