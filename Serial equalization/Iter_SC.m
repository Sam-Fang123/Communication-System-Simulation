
function [data_hat_dec data_hat_bit]=Iter_SC(sys_par,tx_par,K,H,Y,noise_pwr,data)


Q = (K-1)/2;
L = zeros(sys_par.tblock,1);
iter_time = 10;
C = eye(sys_par.tblock);
F = dftmtx(sys_par.tblock)/sqrt(sys_par.tblock);
t_hat_i = zeros(sys_par.tblock,1);

Mask = zeros(sys_par.tblock,sys_par.tblock);
for k=0:sys_par.tblock-1
    rho = mod(k-Q-1+(1:K),sys_par.tblock)+1;
    Mask(rho,k+1) = 1;
end
H = H.*Mask;

for i = 0:iter_time
   
    s_bar_i = tanh(L/2);
    v_i = ones(sys_par.tblock,1) - s_bar_i.^2;
    t_bar_i = F*s_bar_i;
    for k=0:sys_par.tblock-1
        rho = mod(k-Q-1+(1:K),sys_par.tblock)+1;
        H_k = H(rho,:);
        C_k = C(rho,:);
        g_k_i = (H_k*F*diag(v_i)*conj(F.')*conj(H_k.') + C_k*conj(C_k.')*noise_pwr^2)\H_k*F*diag(v_i)*conj(F.')*C(:,k+1);
        t_hat_i(k+1) = t_bar_i(k+1)+conj(g_k_i.')*(Y(rho)-H_k*t_bar_i);
    end
    
    q_sum = 0;
    p_sum = 0;
    for k=0:sys_par.tblock-1
        rho = mod(k-Q-1+(1:K),sys_par.tblock)+1;
        H_k = H(rho,:);
        C_k = C(rho,:);
        g_k_i = (H_k*F*diag(v_i)*conj(F.')*conj(H_k.') + C_k*conj(C_k.')*noise_pwr^2)\H_k*F*diag(v_i)*conj(F.')*C(:,k+1);
        q_sum = q_sum + conj(H_k.')*g_k_i*conj(C(:,k+1).');
        p_sum = p_sum + conj(C_k.')*g_k_i*conj(C(:,k+1).');
    end
    Q_i = conj(F.')*q_sum*F;
    P_i = conj(F.')*p_sum*F;
    s_hat_i = conj(F.')*t_hat_i;
    for ll = 0:sys_par.tblock-1
        L(ll+1) = L(ll+1) + (4*real(Q_i(ll+1,ll+1)*(s_hat_i(ll+1)-s_bar_i(ll+1))) + (abs(Q_i(ll+1,ll+1))^2)*s_bar_i(ll+1))/(conj(Q_i(:,ll+1).')*diag(v_i)*Q_i(:,ll+1) ...
            -(abs(Q_i(ll+1,ll+1))^2)*v_i(ll+1)+conj(P_i(:,ll+1).')*P_i(:,ll+1)*noise_pwr^2);
    end
end
   
for k = 0:sys_par.tblock-1
   data_hat_dec(k+1) = sc_symbol_slicing(s_hat_i(k+1),tx_par); 
end

for ii=1:sys_par.ndata
    data_hat_bit((ii-1)*tx_par.nbits_per_sym+1:ii*tx_par.nbits_per_sym ) = my_dec2base(data_hat_dec(ii),2,tx_par.nbits_per_sym);
end% end ii=1:sys_par.ndata