%%2023/7/28 by Fang Syuan-Siang

function [data_hat_dec, data_hat_bit] = Schniter_Equalizer(sys_par,tx_par,ts_par,rx_par,h,y,noise_pwr,pilot,data,w)

data_hat_dec = zeros(rx_par.iteration,sys_par.ndata);
data_hat_bit = zeros(rx_par.iteration,sys_par.ndata*tx_par.nbits_per_sym);
data_hat_const = zeros(1,sys_par.ndata);
pn_hat_dec = zeros(rx_par.iteration,sys_par.nts);
pn_hat_const = zeros(1,sys_par.nts);

F = fft(eye(sys_par.tblock))/sqrt(sys_par.tblock);
y_w = diag(w)*y;
h_w = diag(w)*h;
Y_W = fft(y_w,sys_par.tblock)/sqrt(sys_par.tblock); %column vector
H_W = fft(h_w,sys_par.tblock)*ifft(eye(sys_par.tblock),sys_par.tblock);

C_beta = F*diag(w)*F';

for ii=1:sys_par.tblock
    H_k = H_W(mod(ii-rx_par.IBDFE.frist_banded_Q-2+(1:2*rx_par.IBDFE.frist_banded_Q+1),sys_par.tblock)+1,:);
end
