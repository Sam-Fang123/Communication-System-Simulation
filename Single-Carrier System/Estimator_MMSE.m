
function [h_est, h_taps_est, c_est] = Estimator_MMSE(sys_par,A,y_O,noise_pwr,observation,est_par,U,w,h_avg_pwr,Rc)

%F = fft(eye(sys_par.tblock))/sqrt(sys_par.tblock);
if(est_par.BEM.window==1)   % OW-basis
    windowed_noise_cov = observation.matrix*diag(w)*noise_pwr*diag(w')*observation.matrix';
else
    windowed_noise_cov = observation.matrix*noise_pwr*observation.matrix';
end

%noise_pwr = windowed_noise_cov(1,1);
%c_est = (inv(Rc)+conj(A.')*A/noise_pwr)\(conj(A.')*y_O)/noise_pwr;
c_est = (A'*A+windowed_noise_cov/Rc)\(A'*y_O);

h_taps_est = U*reshape(c_est,sys_par.M,[]).';

h_est = [fliplr(h_taps_est) zeros(sys_par.tblock,sys_par.tblock-sys_par.M)];
for i = 0:sys_par.tblock-1
    h_est(i+1,:) = circshift(h_est(i+1,:), -(sys_par.M-1-i),2);
end



