function [C]=coeff_MMSE_LE(sys_par,H_FD,signal_pwr,noise_pwr,w,B_mtx2)

F = fft(eye(sys_par.tblock))/sqrt(sys_par.tblock);
windowed_noise_cov = F*diag(w)*noise_pwr*diag(w')*F';
windowed_noise_cov = windowed_noise_cov.*B_mtx2;
K=(windowed_noise_cov/signal_pwr)+H_FD*(H_FD');
C = H_FD'/K;
