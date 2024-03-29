
%%2023/7/28 by Fang Syuan-Siang

function [data_hat_dec, data_hat_bit] = IBDFE_TV(sys_par,tx_par,ts_par,rx_par,h,y,noise_pwr,pilot,data,w)

Y_original = fft(y,sys_par.tblock)/sqrt(sys_par.tblock); %column vector
H_original = fft(h,sys_par.tblock)*ifft(eye(sys_par.tblock),sys_par.tblock);

y_w = diag(w)*y;
h_w = diag(w)*h;
Y_W = fft(y_w,sys_par.tblock)/sqrt(sys_par.tblock); %column vector
H_W = fft(h_w,sys_par.tblock)*ifft(eye(sys_par.tblock),sys_par.tblock);

data_hat_dec = zeros(rx_par.iteration,sys_par.ndata);
data_hat_bit = zeros(rx_par.iteration,sys_par.ndata*tx_par.nbits_per_sym);
data_hat_const = zeros(1,sys_par.ndata);
pn_hat_dec = zeros(rx_par.iteration,sys_par.nts);
pn_hat_const = zeros(1,sys_par.nts);
for n=1:rx_par.iteration
    if (n==1)
        signal_pwr=1;
        decision_pwr=0;  % ?? 0/0 in IBDFE_coeff_T2C1() ??
        cor=0;
        coreff=0;
        
        H_b = H_W.*rx_par.B_mtx;
        [C]=coeff_MMSE_LE(sys_par,H_b,signal_pwr,noise_pwr,w,rx_par.B_mtx2); % ?? check B valid? or NaN

        S_temp = C*Y_W;  % Y is a column vector (ok... here B is not involved. Thus, B being NaN is OK.)         
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
        if(rx_par.IBDFE.D_FB_Full==1)
            if(rx_par.IBDFE.D_FF_Full==1)
                [C, B, beta]=coeff_IBDFE_T2C1(sys_par,H_original,signal_pwr,decision_pwr,noise_pwr,cor,coreff);
            else
                [C, B, beta]=coeff_IBDFE_T3C1(sys_par,H_original,signal_pwr,decision_pwr,noise_pwr,cor,coreff,rx_par.IBDFE.D_FF);
            end
        else       
            [C, B, beta]=coeff_IBDFE_T4C1(sys_par,H_original,signal_pwr,decision_pwr,noise_pwr,cor,coreff,rx_par.IBDFE.D_FF,rx_par.IBDFE.D_FB);
        end
        hc = beta;     
        S_temp=C*Y_original+B*S_dec;
    end%end if (n==1)
    
    s_temp=ifft(S_temp).*sqrt(sys_par.tblock); % normalized    
    s_temp = s_temp ./hc;  % hc is a vector
    S_temp = fft(s_temp)/sqrt(sys_par.tblock); % normalized
    
    data_temp=s_temp(data.position); %remove TS
    pn_temp=s_temp(reshape(pilot.position.',1,[])); %TS
    
    %Symbol Slicing
    for ii=1:sys_par.ndata
        [data_hat_dec(n,ii), data_hat_const(ii)] = sc_symbol_slicing(data_temp(ii),tx_par,data.power);
    end%end ii=1:sys_par.ndata
    
    if(sys_par.ts_type == 1)    % Non-optimal
        for ii=1:sys_par.nts
            [pn_hat_dec(n,ii), pn_hat_const(ii)] = sc_symbol_slicing(pn_temp(ii),ts_par,pilot.power);
        end%end ii=1:sys_par.nts
    else    % Optimal
        pn_hat_dec(pilot.off_index) = 0;
        pn_hat_const(pilot.off_index) = 0;
        for ii=1:pilot.on_num
            kk = pilot.on_index(ii);
            [pn_hat_dec(n,kk), pn_hat_const(kk)] = sc_symbol_slicing(pn_temp(kk),ts_par,pilot.power);
        end  
    end
  
    
    %Translate to bits
    for ii=1:sys_par.ndata
        data_hat_bit(n,(ii-1)*tx_par.nbits_per_sym+1:ii*tx_par.nbits_per_sym ) = my_dec2base(data_hat_dec(n,ii),2,tx_par.nbits_per_sym);
    end% end ii=1:sys_par.ndata
    
    s_dec = zeros(sys_par.tblock,1);
    s_dec(data.position) = data_hat_const*sqrt(data.power);
    s_dec(reshape(pilot.position.',1,[])) = pn_hat_const*sqrt(pilot.power);
    S_dec=fft(s_dec,sys_par.tblock)./sqrt(sys_par.tblock);
    
    S_est = S_temp;  % estimate of S; used for correlation estimation.

end %end n=1:sys_par.iteration