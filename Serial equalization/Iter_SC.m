
function [data_hat_dec data_hat_bit]=Iter_SC(sys_par,tx_par,K,H,Y,noise_pwr,data)

Q = (K-1)/2;
L = zeros(sys_par.tblock,1);
iter_time = 10;
C = eye(sys_par.tblock);
F = dftmtx(sys_par.tblock)/sqrt(sys_par.tblock);

for i = 0:iter_time
   
    s_bar_i = tanh(L/2);
    v_i = ones(sys_par.tblock,1) - s_bar_i.^2;
    t_bar_i = F*s_bar_i;
    for k=0:sys_par.tblock-1
        rho = mod(k-Q-1+(1:K),sys_par.tblock)+1;
        H_k = H(rho,:);
        C_k = C(rho,:);
        g_k_i = (H_k*F*diag(v_i)*F.''*H_k.'')%
        R_k = A_k*conj(A_k.') + noise_pwr*eye(K);
        m_k = R_k\A_k(:,k+1);
        s_hat_k(k+1) = sc_symbol_slicing(conj(m_k.')*Y(rho),tx_par);
    end

data_hat_dec = s_hat_k;

for ii=1:sys_par.ndata
    data_hat_bit((ii-1)*tx_par.nbits_per_sym+1:ii*tx_par.nbits_per_sym ) = my_dec2base(data_hat_dec(ii),2,tx_par.nbits_per_sym);
end% end ii=1:sys_par.ndata