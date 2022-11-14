
function [data_hat_dec, data_hat_bit]=TD_LMMSE(sys_par,tx_par,h,y,noise_pwr,data)

G_H = conj(h.')/(h*conj(h.')+noise_pwr*diag(sys_par.tblock));
s_tilde = G_H*y;
for k=0:sys_par.tblock-1
    s_hat_k(k+1) = sc_symbol_slicing(s_tilde(k+1),tx_par);
end
data_hat_dec = s_hat_k;

for ii=1:sys_par.ndata
    data_hat_bit((ii-1)*tx_par.nbits_per_sym+1:ii*tx_par.nbits_per_sym ) = my_dec2base(data_hat_dec(ii),2,tx_par.nbits_per_sym);
end% end ii=1:sys_par.ndata
