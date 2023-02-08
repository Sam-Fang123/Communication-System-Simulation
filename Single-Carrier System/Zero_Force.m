
function [data_hat_dec data_hat_bit] = Zero_Force(sys_par,tx_par,rx_par,h,y,noise_pwr,pilot,data,w)

data_hat_dec = zeros(1,sys_par.ndata);
data_hat_const = zeros(1,sys_par.ndata);

switch(rx_par.ZF.method)
    case(1) %block-by-block ZF
        y_dec = (conj(h.')*h)\conj(h.')*y;
        y_data = y_dec(data.position);    
         %Symbol Slicing
        for ii=1:size(data.position,2)
            [data_hat_dec(ii) data_hat_const(ii)] = sc_symbol_slicing(y_data(ii),tx_par);
        end%end ii=1:sys_par.ndata
        
        %Translate to bits
        for ii=1:sys_par.ndata
            data_hat_bit((ii-1)*tx_par.nbits_per_sym+1:ii*tx_par.nbits_per_sym ) = my_dec2base(data_hat_dec(ii),2,tx_par.nbits_per_sym);
        end% end ii=1:sys_par.ndata
    case(2)  %symbol-by-symbol ZF
        e = [1 zeros(1,sys_par.tblock-1)];
        for ii = 1:size(data.position,2)
            e_shift = circshift(e,data.position(ii)-1);
            w = conj(h.')\e_shift.';
            y_dec = conj(w.')*y;
            %y_data = y_dec(data.position(ii));
            [data_hat_dec(ii) data_hat_const(ii)] = sc_symbol_slicing(y_dec,tx_par);
        end
        for ii=1:sys_par.ndata
            data_hat_bit((ii-1)*tx_par.nbits_per_sym+1:ii*tx_par.nbits_per_sym ) = my_dec2base(data_hat_dec(ii),2,tx_par.nbits_per_sym);
        end% end ii=1:sys_par.ndata
end

        
        
        
        
        