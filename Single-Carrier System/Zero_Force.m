
function [data_hat_dec data_hat_bit] = Zero_Force(sys_par,tx_par,ts_par,rx_par,h,y,noise_pwr,pilot,data,w)

data_hat_dec = zeros(1,sys_par.ndata);
data_hat_const = zeros(1,sys_par.ndata);
if(sys_par.cpzp_type==2)    %ZP
    h_zp = h(:,1:end-sys_par.L);
    y_dec = pinv(h_zp)*y;
else
    y_dec = pinv(h)*y;
end
y_data = y_dec(data.position); 
 %Symbol Slicing
for ii=1:size(data.position,2)
    [data_hat_dec(ii) data_hat_const(ii)] = sc_symbol_slicing(y_data(ii),tx_par,data.power);
end%end ii=1:sys_par.ndata
        
%Translate to bits
for ii=1:sys_par.ndata
    data_hat_bit((ii-1)*tx_par.nbits_per_sym+1:ii*tx_par.nbits_per_sym ) = my_dec2base(data_hat_dec(ii),2,tx_par.nbits_per_sym);
end% end ii=1:sys_par.ndata
        
end

        
        
        
        
        