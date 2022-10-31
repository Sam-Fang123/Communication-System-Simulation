function [C B beta]=coeff_IBDFE_T2C1_Quasibanded(sys_par,H,signal_pwr,decision_pwr,noise_pwr,cor,coreff,D,w)

F = fft(eye(sys_par.tblock))/sqrt(sys_par.tblock);
windowed_noise_cov = F*diag(w)*noise_pwr*diag(w')*F';

temp = eye(sys_par.tblock);
mask = zeros(sys_par.tblock,sys_par.tblock);
for shift = -D:D
    mask = mask + circshift(temp,shift);
end
H_mask = H.*mask;
K=(windowed_noise_cov/signal_pwr)+(1-coreff)*(H_mask*H_mask');
C = H_mask'/K;
beta = sum(diag(C*H_mask),1)/sys_par.tblock;
B=-cor/decision_pwr*(C*H_mask-beta*eye(sys_par.tblock));
