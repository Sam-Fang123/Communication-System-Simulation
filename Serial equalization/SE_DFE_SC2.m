

function [data_hat_dec_out, data_hat_bit]=SE_DFE_SC2(sys_par,tx_par,rx_par,K_SC,h,y,noise_pwr,data,w)

K = K_SC;
Q = (K-1)/2;
w_diag = diag(w.w);
[max_norm m] = max(vecnorm(h));
m = m-1;
iter_num = rx_par.SE.SC_PIC_iter;
s_hat_k = zeros(iter_num+1,sys_par.tblock);
data_hat_dec = zeros(iter_num+1,sys_par.tblock);
% first iteration
rho = mod(m-Q-1+(1:K),sys_par.tblock)+1;
A_k = h(rho,:);
R_k = A_k*conj(A_k.') + noise_pwr*w_diag(rho,:)*conj(w_diag(rho,:).');
m_k = R_k\A_k(:,m+1);
[data_hat_dec(1,m+1), s_hat_k(1,m+1)]  = sc_symbol_slicing(conj(m_k.')*y(rho),tx_par);

rho2 = mod(m:m+sys_par.tblock-1,sys_par.tblock);
n_k = 1;
for k=rho2(2:end)
    rho = mod(k-Q-1+(1:K),sys_par.tblock)+1;
    A_k = h(rho,:);
    Y_tilde_k = y(rho);
    for ii=1:n_k
        Y_tilde_k = Y_tilde_k - A_k(:,rho2(ii)+1)*s_hat_k(1,rho2(ii)+1);
    end
    A_k_tilde = A_k(:,rho2(n_k+1:end)+1);
    R_k = A_k_tilde*conj(A_k_tilde.') + noise_pwr*w_diag(rho,:)*conj(w_diag(rho,:).');
    m_k = R_k\A_k(:,k+1);
    n_k = n_k+1;
    [data_hat_dec(1,k+1), s_hat_k(1,k+1)] = sc_symbol_slicing(conj(m_k.')*Y_tilde_k,tx_par);
end

%for ii=1:sys_par.ndata
%    data_hat_bit(1,(ii-1)*tx_par.nbits_per_sym+1:ii*tx_par.nbits_per_sym ) = my_dec2base(data_hat_dec(1,ii),2,tx_par.nbits_per_sym);
%end% end ii=1:sys_par.ndata

for ii = 1:iter_num
    for kk = 0:sys_par.tblock-1
        rho3 = mod(kk-Q-1+(1:K),sys_par.tblock)+1;
        Y_k = y(rho3);
        A_k = h(rho3,:);
        for kkk = 0:sys_par.tblock-1
            if(kkk~=kk)
                Y_k = Y_k - A_k(:,kkk+1)*s_hat_k(ii,kkk+1);
            end
        end
        z_k = conj(A_k(:,kk+1).')*Y_k;
        [data_hat_dec(ii+1,kk+1), s_hat_k(ii+1,kk+1)] = sc_symbol_slicing(z_k,tx_par);
    end
    %for jj=1:sys_par.ndata
    %    data_hat_bit(ii+1,(jj-1)*tx_par.nbits_per_sym+1:jj*tx_par.nbits_per_sym ) = my_dec2base(data_hat_dec(ii+1,jj),2,tx_par.nbits_per_sym);
    %end% end ii=1:sys_par.ndata
end  
data_hat_dec_out = data_hat_dec(iter_num+1,:);

for ii=1:sys_par.ndata
    data_hat_bit((ii-1)*tx_par.nbits_per_sym+1:ii*tx_par.nbits_per_sym ) = my_dec2base(data_hat_dec(iter_num+1,ii),2,tx_par.nbits_per_sym);
end% end ii=1:sys_par.ndata