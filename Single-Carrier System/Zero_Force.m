
function [data_hat_dec data_hat_bit] = Zero_Force(sys_par,tx_par,ts_par,rx_par,h,y,noise_pwr,pilot,data,w)

data_hat_dec = zeros(1,sys_par.ndata);
data_hat_const = zeros(1,sys_par.ndata);

switch(rx_par.ZF.method)
    case(1) %block-by-block ZF
        %y_dec = (conj(h.')*h)\conj(h.')*y;
        if(sys_par.tx_type ==2 )    % ZP
            %y_dec = pinv(h(1:end-sys_par.L,1:end-sys_par.L))*y(1:end-sys_par.L);
            y_dec = pinv(h)*y; 
            %y_dec = h\y;
        else
            %y_dec = h\y;
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
        
    case(2)  %symbol-by-symbol ZF
        
        e = [1 zeros(1,sys_par.tblock-1)].';
        
        for ii=1:sys_par.ndata
            e_shift = circshift(e,data.position(ii)-1);
            W = pinv(conj(h.'))*e_shift;
            y_data = conj(W.')*y;
            [data_hat_dec(ii) data_hat_const(ii)] = sc_symbol_slicing(y_data,tx_par,data.power);
        end
            
        for ii=1:sys_par.ndata
            data_hat_bit((ii-1)*tx_par.nbits_per_sym+1:ii*tx_par.nbits_per_sym ) = my_dec2base(data_hat_dec(ii),2,tx_par.nbits_per_sym);
        end% end ii=1:sys_par.ndata
        
    case(3) % symbol-by-symbol ZF (Faster but only for slow fading channel?), cant use in CP case??
        delay = floor(sys_par.tblock/2);
        e = [zeros(1,delay) 1 zeros(1,sys_par.tblock-1-delay)].';
        h_H = conj(h.');
        W = pinv(h_H)*e;
        y_dec = conv(W,y);
        y_dec = y_dec(delay+1:delay+sys_par.tblock);
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

        
        
        
        
        