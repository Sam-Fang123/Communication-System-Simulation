
function [data_hat_dec_out, data_hat_bit]=SE_DFE_SC3(sys_par,tx_par,rx_par,h,y,noise_pwr,data,w)


h_eff = h(:,1:end-sys_par.M+1);
y_tilde = y(2:sys_par.tblock-sys_par.M);
y_hat = zeros(1,sys_par.tblock-sys_par.M);
data_hat_dec_out = zeros(1,sys_par.tblock-sys_par.M);

for ii = 2:sys_par.tblock-sys_par.M
    for jj = 1:ii-1
        if jj==1
            y_tilde(ii-1) = y_tilde(ii-1) - h_eff(ii,jj)*data.const_data(jj);
        else
            y_tilde(ii-1) = y_tilde(ii-1) - h_eff(ii,jj)*y_hat(jj-1);
        end
    end
    switch(rx_par.SE.type)
        case(1) %ZF
            y_tilde(ii-1) = y_tilde(ii-1)/h_eff(ii,ii);
        case(2) %EGC
            y_tilde(ii-1) = y_tilde(ii-1)*conj(h_eff(ii,ii))/abs(h_eff(ii,ii));
        case(3) %MRC
            y_tilde(ii-1) = y_tilde(ii-1)*conj(h_eff(ii,ii));
        case(4)
            y_tilde(ii-1) = y_tilde(ii-1)*conj(h_eff(ii,ii))/(abs(h(ii,ii))^2+noise_pwr);
    end
    [data_hat_dec_out(ii-1), y_hat(ii-1)] = sc_symbol_slicing(y_tilde(ii-1),tx_par);
end

for ii=1:sys_par.tblock-sys_par.M
    data_hat_bit((ii-1)*tx_par.nbits_per_sym+1:ii*tx_par.nbits_per_sym ) = my_dec2base(data_hat_dec_out(ii),2,tx_par.nbits_per_sym);
end% end ii=1:sys_par.ndata