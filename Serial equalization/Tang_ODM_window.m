
function [w]=Tang_ODM_window(sys_par,rx_par,fade_struct,snr,Q)

N = sys_par.tblock;
F = dftmtx(N)/sqrt(N);
B_N = [F(:,Q/2+1) F(:,Q/2)];
Rho_BN = eye(N)-B_N*pinv(B_N);
I = eye(N);

for m = 1:N
    for n = 1:N
        R_HH(m,n) = besselj(0,2*pi*fade_struct.nor_fd*(m-n));
    end
end

X_sum = 0;
for n=1:N
    X_sum = X_sum + diag(Rho_BN.'*I(:,n))*R_HH*diag(conj(Rho_BN.')*I(:,n));
end
X_N = B_N.'*X_sum*conj(B_N);
[V,D] = eig(X_N);
dd = diag(D); 
[m,i] = min(dd);
d_hat = V(:,i);
w = B_N*d_hat;

