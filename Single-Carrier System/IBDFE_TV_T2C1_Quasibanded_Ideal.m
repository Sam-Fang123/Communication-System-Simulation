function [data_hat_dec data_hat_bit]=IBDFE_TV_T2C1_Quasibanded_Ideal(sys_par,tx_par,rx_par,H,Y,trans_block_FD,noise_pwr,pilot,data,w)

    signal_pwr=1;
    decision_pwr=1;
    cor=1;
    coreff=1;
    [C B beta]=coeff_IBDFE_T2C1_Quasibanded(sys_par,H,signal_pwr,decision_pwr,noise_pwr,cor,coreff,rx_par.IBDFE.D,w);
    S_dec=trans_block_FD;% ideal FB
    S_temp=C*Y+B*S_dec;
    s_temp=ifft(S_temp).*sqrt(sys_par.tblock);  
    hc = beta;
    s_temp = s_temp/hc;
    data_temp=s_temp(data.position); %remove TS
    pn_temp=s_temp(reshape(pilot.position.',1,[])); %TS
    

    %Symbol Slicing
    for ii=1:size(data.position,2)
        [data_hat_dec(1,ii) data_hat_const(ii)] = sc_symbol_slicing(data_temp(ii),tx_par);
    end%end ii=1:sys_par.ndata
    
    for ii=1:size(reshape(pilot.position.',1,[]),2)
        [pn_hat_dec(1,ii) pn_hat_const(ii)] = sc_symbol_slicing(pn_temp(ii),tx_par);
    end%end ii=1:sys_par.nts
    
    %Translate to bits
    for ii=1:sys_par.ndata
        data_hat_bit(1,(ii-1)*tx_par.nbits_per_sym+1:ii*tx_par.nbits_per_sym ) = my_dec2base(data_hat_dec(1,ii),2,tx_par.nbits_per_sym);
    end% end ii=1:sys_par.ndata
end