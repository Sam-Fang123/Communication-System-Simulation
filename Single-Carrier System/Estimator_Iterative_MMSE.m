
function [h_est, h_taps_est, c_est] = Estimator_Iterative_MMSE(sys_par,A,y_O,noise_pwr,observation,est_par,U,w,h_avg_pwr,Rc)

F = fft(eye(sys_par.tblock))/sqrt(sys_par.tblock);
windowed_noise_cov = F*diag(w)*noise_pwr*diag(w')*F';
noise_pwr = windowed_noise_cov(1,1);
c_est = (inv(Rc)+conj(A.')*A/noise_pwr)\(conj(A.')*y_O)/noise_pwr;
h_taps_est = U*reshape(c_est,sys_par.M,[]).';

h_est = [fliplr(h_taps_est) zeros(sys_par.tblock,sys_par.tblock-sys_par.M)];
for i = 0:sys_par.tblock-1
    h_est(i+1,:) = circshift(h_est(i+1,:), -(sys_par.M-1-i),2);
end

end


