%%2023/7/28 by Fang Syuan-Siang

function [data_hat_dec, data_hat_bit] = Schniter(sys_par,tx_par,ts_par,rx_par,h,y,noise_pwr,pilot,data,w)

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
%C_beta = C_beta.*rx_par.B_mtx;
I = eye(sys_par.tblock);
t_hat = zeros(sys_par.tblock,1);
LLR_s = zeros(sys_par.tblock,1);

for n=1:rx_par.iteration
    s_bar = tanh(LLR_s/2)*sqrt(data.power);
    s_bar(reshape(pilot.position.',1,[]))=reshape(pilot.clusters_symbol.',1,[]);
    v = ones(sys_par.tblock,1).*data.power-s_bar.^2;
    v(reshape(pilot.position.',1,[]))=0;
    diag_v = diag(v);
    t_bar = F*s_bar;
    H_sum = zeros(sys_par.tblock,sys_par.tblock);
    C_sum = zeros(sys_par.tblock,sys_par.tblock);
    
    for kk = 1:sys_par.tblock
        H_k = H_W(mod(kk-rx_par.IBDFE.frist_banded_Q-2+(1:2*rx_par.IBDFE.frist_banded_Q+1),sys_par.tblock)+1,:);
        C_k = C_beta(mod(kk-rx_par.IBDFE.frist_banded_Q-2+(1:2*rx_par.IBDFE.frist_banded_Q+1),sys_par.tblock)+1,:);
        Y_k = Y_W(mod(kk-rx_par.IBDFE.frist_banded_Q-2+(1:2*rx_par.IBDFE.frist_banded_Q+1),sys_par.tblock)+1);
        g_k = (H_k*F*diag_v*F'*H_k' + noise_pwr*(C_k*C_k'))\(H_k*F*diag_v*F'*I(:,kk));
        t_hat(kk) = t_bar(kk) + g_k'*(Y_k-H_k*t_bar);
        
        H_sum = H_sum + H_k'*g_k*I(:,kk)';
        C_sum = C_sum + C_k'*g_k*I(:,kk)';
    end
    
    Q = F'*H_sum*F;
    P = F'*C_sum*F;
    s_hat = F'*t_hat;
    
    data_temp = s_hat(data.position);
    %Symbol Slicing
    for ii=1:sys_par.ndata
        [data_hat_dec(n,ii), data_hat_const(ii)] = sc_symbol_slicing(data_temp(ii),tx_par,data.power);
    end%end ii=1:sys_par.ndata

    for ii=1:sys_par.ndata
            data_hat_bit(n,(ii-1)*tx_par.nbits_per_sym+1:ii*tx_par.nbits_per_sym ) = my_dec2base(data_hat_dec(n,ii),2,tx_par.nbits_per_sym);
    end% end ii=1:sys_par.ndata
    
    for ii=1:sys_par.tblock
        LLR_s(ii)=LLR_s(ii)+4*(real(Q(ii,ii)*(s_hat(ii)-s_bar(ii)))+s_bar(ii)*Q(ii,ii)*Q(ii,ii)')/(Q(:,ii)'*diag_v*Q(:,ii)-v(ii)*Q(ii,ii)*Q(ii,ii)'+noise_pwr*P(:,ii)'*P(:,ii));
    end
end
    
        


