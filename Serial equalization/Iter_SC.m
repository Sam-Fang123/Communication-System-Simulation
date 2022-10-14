
function [data_hat_dec data_hat_bit]=Iter_SC(sys_par,tx_par,K,H,Y,noise_pwr,data)

Q = (K-1)/2;

for k=0:sys_par.tblock-1
    rho = mod(k-Q-1+(1:K),sys_par.tblock)+1;
    A_k = H(rho,:);
    R_k = A_k*conj(A_k.') + noise_pwr*eye(K);
    m_k = R_k\A_k(:,k+1);
    s_hat_k(k+1) = sc_symbol_slicing(conj(m_k.')*Y(rho),tx_par);
end

data_hat_dec = s_hat_k;

for ii=1:sys_par.ndata
    data_hat_bit((ii-1)*tx_par.nbits_per_sym+1:ii*tx_par.nbits_per_sym ) = my_dec2base(data_hat_dec(ii),2,tx_par.nbits_per_sym);
end% end ii=1:sys_par.ndata