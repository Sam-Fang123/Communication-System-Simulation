
function [w]=Iter_SC_window(sys_par,rx_par,fade_struct,snr,Q)

N = sys_par.tblock;
F = dftmtx(N)/sqrt(N);
B_N = [F(:,Q/2+1) F(:,Q/2)];
Rho_BN = eye(N)-B_N*pinv(B_N);
for m = 0:N-1
    for n = 0:N-1
        R_HH(m,n) = besselj(0,2*pi*fade_struct.nor_fd*(m-n));
    end
end
