% 
%  ~ 2022/5/2
%  1. divided by beta before slicing
%  2. Three correlation estimation method are supported(1.Genie-Aided 2.Using TS 3.A Way proposed by Our Lab)
%

function [data_hat_dec data_hat_bit] = IBDFE_TV_T1C1(sys_par,tx_par,ts_par,rx_par,H,Y,noise_pwr,pilot,data,w)

for n=1:rx_par.iteration
    if (n==1)
        signal_pwr=1;
        decision_pwr=0;  % ?? 0/0 in IBDFE_coeff_T2C1() ??
        cor=0;
        coreff=0; % ok
        if(rx_par.IBDFE.first_iteration_full == 1)
            [C B beta]=coeff_IBDFE_T2C1(sys_par,H,signal_pwr,decision_pwr,noise_pwr,cor,coreff,w); % ?? check B valid? or NaN
        else
            [C B beta]=coeff_IBDFE_T1C1(sys_par,H,signal_pwr,decision_pwr,noise_pwr,cor,coreff,w); 
        end
        S_temp = C*Y;  % Y is a column vector (ok... here B is not involved. Thus, B being NaN is OK.)         
        hc = 1; % MMSE-LE criterion enforces this
    else
        signal_pwr=1;
        decision_pwr=sum(abs(S_dec).^2,1)/sys_par.tblock;  % ? no thresholding is applied
        switch(rx_par.IBDFE.cor_type)
            case(1)
                trans_block = zeros(sys_par.tblock,1);
                trans_block(reshape(pilot.position.',1,[])) = reshape(pilot.clusters_symbol.',1,[]);
                trans_block(data.position) = data.const_data;
                cor=sum(trans_block.*conj(s_dec),1)/sys_par.tblock;
            case(2)
                 pilot_symbol = reshape(pilot.clusters_symbol.',1,[]);
                 cor=rx_par.IBDFE.eta*sum(pilot_symbol.*conj(pn_hat_const),2)/sys_par.nts;
            case(3)
                cor=rx_par.IBDFE.eta*sum((S_est.')* conj(S_dec))/sys_par.tblock;
            case(4)
                error("Correlation Type 4 is for IBDFE_TI.");
            case(5)
                error("Correlation Type 5 is for IBDFE_TI.");
        end
        
        coreff=abs(cor)^2/(decision_pwr*signal_pwr);
        if (coreff>1)  % cap out to 1
            coreff=1;
        end
        
        [C B beta]=coeff_IBDFE_T1C1(sys_par,H,signal_pwr,decision_pwr,noise_pwr,cor,coreff,w);
        hc = beta;     
        S_temp=C*Y+B*S_dec;
    end%end if (n==1)
    
    s_temp=ifft(S_temp).*sqrt(sys_par.tblock); % normalized    
    s_temp = s_temp ./hc;  % hc is a vector
    S_temp = fft(s_temp)/sqrt(sys_par.tblock); % normalized
    
    data_temp=s_temp(data.position); %remove TS
    pn_temp=s_temp(reshape(pilot.position.',1,[])); %TS
    
    %Symbol Slicing
    for ii=1:size(data.position,2)
        [data_hat_dec(n,ii) data_hat_const(ii)] = sc_symbol_slicing(data_temp(ii),tx_par,data.power);
    end%end ii=1:sys_par.ndata
    
    for ii=1:size(reshape(pilot.position.',1,[]),2)
        [pn_hat_dec(n,ii) pn_hat_const(ii)] = sc_symbol_slicing(pn_temp(ii),ts_par,pilot.power);
    end%end ii=1:sys_par.nts
    
    %Translate to bits
    for ii=1:sys_par.ndata
        data_hat_bit(n,(ii-1)*tx_par.nbits_per_sym+1:ii*tx_par.nbits_per_sym ) = my_dec2base(data_hat_dec(n,ii),2,tx_par.nbits_per_sym);
    end% end ii=1:sys_par.ndata
    
    s_dec = zeros(sys_par.tblock,1);
    s_dec(data.position) = data_hat_const;
    s_dec(reshape(pilot.position.',1,[])) = pn_hat_const;
    S_dec=fft(s_dec,sys_par.tblock)./sqrt(sys_par.tblock);
    
    S_est = S_temp;  % estimate of S; used for correlation estimation.

end %end n=1:sys_par.iteration