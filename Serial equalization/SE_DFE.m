

function [data_hat_dec_out data_hat_bit]=SE_DFE(sys_par,tx_par,K,H,Y,noise_pwr,data)

Q = (K-1)/2;
[max_norm m] = max(vecnorm(H));
m = m-1; % Symbol index is from 0 to N-1
iter_num = 2;
s_hat_k = zeros(iter_num+1,sys_par.tblock);
data_hat_dec = zeros(iter_num+1,sys_par.tblock);
% first iteration
rho = mod(m-Q-1+(1:K),sys_par.tblock)+1;
A_k = H(rho,:);
R_k = A_k*conj(A_k.') + noise_pwr*eye(K);
m_k = R_k\A_k(:,m+1);
[data_hat_dec(1,m+1) s_hat_k(1,m+1)]  = sc_symbol_slicing(conj(m_k.')*Y(rho),tx_par);

rho2 = mod(m:m+sys_par.tblock-1,sys_par.tblock);
n_k = 1;
for k=rho2(2:end)
    rho = mod(k-Q-1+(1:K),sys_par.tblock)+1;
    A_k = H(rho,:);
    Y_tilde_k = Y(rho);
    for ii=1:n_k
        Y_tilde_k = Y_tilde_k - A_k(:,rho2(ii)+1)*s_hat_k(1,rho2(ii)+1);
    end
    A_k_tilde = A_k(:,rho2(n_k+1:end)+1);
    R_k = A_k_tilde*conj(A_k_tilde.')+noise_pwr*eye(K);
    m_k = R_k\A_k(:,k+1);
    n_k = n_k+1;
    [data_hat_dec(1,k+1) s_hat_k(1,k+1)] = sc_symbol_slicing(conj(m_k.')*Y_tilde_k,tx_par);
end

for ii = 1:iter_num
    for kk = 0:sys_par.tblock-1
        rho3 = mod(kk-Q-1+(1:K),sys_par.tblock)+1;
        Y_k = Y(rho3);
        A_k = H(rho3,:);
        for kkk = 0:sys_par.tblock-1
            if(kkk~=kk)
                Y_k = Y_k - A_k(:,kkk+1)*s_hat_k(ii,kkk+1);
            end
        end
        z_k = conj(A_k(:,kk+1).')*Y_k;
        [data_hat_dec(ii+1,kk+1) s_hat_k(ii+1,kk+1)] = sc_symbol_slicing(z_k,tx_par);
    end
end
    
data_hat_dec_out = data_hat_dec(3,:);
for ii=1:sys_par.ndata
    data_hat_bit((ii-1)*tx_par.nbits_per_sym+1:ii*tx_par.nbits_per_sym ) = my_dec2base(data_hat_dec(iter_num+1,ii),2,tx_par.nbits_per_sym);
end% end ii=1:sys_par.ndata