
function [w w_FD_mtx]=Tang_window(sys_par,rx_par,fade_struct,snr,Q,window_par)

N = sys_par.tblock;
F = dftmtx(N)/sqrt(N);
switch(window_par.type)
    case(2)     % ODM
        B_N = [F(:,1:Q/2+1) F(:,end-Q/2+1:end)];
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
        [V,D] = eig(conj(X_N));
        dd = diag(D); 
        [m,i] = min(dd);
        d_hat = V(:,i);
        w = B_N*d_hat;
        w = w*sqrt(N/sum(w.^2));
        %plot(0:N-1,abs(w))
        Beta = F*w/sqrt(N);
        w_FD_mtx = F*diag(sqrt(N)*conj(F.')*Beta)*conj(F.');
end




