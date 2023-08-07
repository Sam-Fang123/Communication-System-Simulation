%%2023/7/28 by Fang Syuan-Siang

function [data_hat_dec, data_hat_bit] = Schniter_Equalizer(sys_par,tx_par,ts_par,rx_par,h,y,noise_pwr,pilot,data,w)

data_hat_dec = zeros(rx_par.iteration,sys_par.ndata);
data_hat_bit = zeros(rx_par.iteration,sys_par.ndata*tx_par.nbits_per_sym);
data_hat_const = zeros(1,sys_par.ndata);

F = fft(eye(sys_par.tblock))/sqrt(sys_par.tblock);
y_w = diag(w)*y;
h_w = diag(w)*h;
Y_W = fft(y_w,sys_par.tblock)/sqrt(sys_par.tblock); %column vector
H_W = fft(h_w,sys_par.tblock)*ifft(eye(sys_par.tblock),sys_par.tblock);
C_beta = F*diag(w)*F';

H_W = H_W.*rx_par.B_mtx;
C_beta = C_beta.*rx_par.B_mtx;
% initialize (first iteration)
I = eye(sys_par.tblock);
s_bar = zeros(sys_par.tblock,1);
s_bar(reshape(pilot.position.',1,[]))=reshape(pilot.clusters_symbol.',1,[]);
s_var = ones(sys_par.tblock,1);
s_var(reshape(pilot.position.',1,[]))=0;
diag_v = diag(s_var);
t_hat = zeros(sys_par.tblock,1);

for n = 1:rx_par.iteration
    t_bar = F*s_bar;
    for kk = 1:sys_par.tblock
        H_k = H_W(mod(kk-rx_par.IBDFE.frist_banded_Q-2+(1:2*rx_par.IBDFE.frist_banded_Q+1),sys_par.tblock)+1,:);
        C_k = C_beta(mod(kk-rx_par.IBDFE.frist_banded_Q-2+(1:2*rx_par.IBDFE.frist_banded_Q+1),sys_par.tblock)+1,:);
        Y_k = Y_W(mod(kk-rx_par.IBDFE.frist_banded_Q-2+(1:2*rx_par.IBDFE.frist_banded_Q+1),sys_par.tblock)+1);
        g_k = (H_k*F*diag_v*F'*H_k' + noise_pwr*(C_k*C_k'))\(H_k*F*diag_v*F'*I(:,kk));
        t_hat(kk) = t_bar(kk) + g_k'*(Y_k-H_k*t_bar);
    end
    s_hat = ifft(t_hat).*sqrt(sys_par.tblock);
    data_temp = s_hat(data.position);

    %Symbol Slicing
    for ii=1:sys_par.ndata
        [data_hat_dec(n,ii), data_hat_const(ii)] = sc_symbol_slicing(data_temp(ii),tx_par,data.power);
    end%end ii=1:sys_par.ndata

    for ii=1:sys_par.ndata
            data_hat_bit(n,(ii-1)*tx_par.nbits_per_sym+1:ii*tx_par.nbits_per_sym ) = my_dec2base(data_hat_dec(n,ii),2,tx_par.nbits_per_sym);
    end% end ii=1:sys_par.ndata

    s_bar(data.position) = data_hat_const*sqrt(data.power);
    s_bar(reshape(pilot.position.',1,[]))=reshape(pilot.clusters_symbol.',1,[]);
    diag_v = zeros(sys_par.tblock,sys_par.tblock);
end


