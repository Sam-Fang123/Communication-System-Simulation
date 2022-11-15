

function [data_hat_dec, data_hat_bit] = SE_MMSE_SC(sys_par,tx_par,rx_par,K_SC,h,y,noise_pwr,data,w)
K = K_SC;
w_diag = diag(w.w);
s_hat_k = zeros(1,sys_par.tblock);
for k=0:sys_par.tblock-1
    rho = mod(k-1+(1:K),sys_par.tblock)+1;
    A_k = h(rho,:);
    R_k = A_k*conj(A_k.') + noise_pwr*w_diag(rho,:)*conj(w_diag(rho,:).');
    m_k = R_k\A_k(:,k+1);
    s_hat_k(k+1) = sc_symbol_slicing(conj(m_k.')*y(rho),tx_par);
end

data_hat_dec = s_hat_k;

for ii=1:sys_par.ndata
    data_hat_bit((ii-1)*tx_par.nbits_per_sym+1:ii*tx_par.nbits_per_sym ) = my_dec2base(data_hat_dec(ii),2,tx_par.nbits_per_sym);
end% end ii=1:sys_par.ndata