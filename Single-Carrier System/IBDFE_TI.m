% 2022/5/4 modified to fit BEM frame
%

function [data_hat_dec, data_hat_bit]=IBDFE_TI(sys_par,tx_par,ts_par,rx_par,h,h_taps,y,noise_pwr,pilot,data)
hh=[fliplr(h_taps) zeros(sys_par.tblock,sys_par.tblock-sys_par.M)];
for m=1:sys_par.tblock
    h(m,:)=circshift(hh(floor(sys_par.tblock/2),:),-sys_par.M+m,2);
end% end m=1:Nsample

Y = fft(y,sys_par.tblock)/sqrt(sys_par.tblock); %column vector
H = fft(h,sys_par.tblock)*ifft(eye(sys_par.tblock),sys_par.tblock);
data_hat_dec = zeros(rx_par.iteration,sys_par.ndata);
data_hat_bit = zeros(rx_par.iteration,sys_par.ndata*tx_par.nbits_per_sym);
data_hat_const = zeros(1,sys_par.ndata);
pn_hat_dec = zeros(rx_par.iteration,sys_par.nts);
pn_hat_const = zeros(1,sys_par.nts);

 % IBDFE-TI uses diagonal of H matrix to compute coefficient
 H=diag(H);%column vector
 H_sq = H .* conj(H);  % abs().^2; column vector 

for n=1:rx_par.iteration
    
    if (n==1)
        C=conj(H)./(H_sq + noise_pwr); % Feedforward filter coefficients
        B=0; 								% Feedback filter coefficients 
		beta=sum(C.*H)/sys_par.tblock;
        
        signal_pwr=1;
        decision_pwr=0;  % ?? 0/0 in IBDFE_coeff_T2C1() ??
        cor=0;
        coreff=0; % ok
        S_temp=diag(C)*Y;  % Y is a column vector (ok... here B is not involved. Thus, B being NaN is OK.)         
        hc=beta; % check if ~1
        
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
                cor=sum( (Y./H) .* conj(S_dec),1)/sys_par.tblock;
            case(5)
                H_th=sqrt(noise_pwr); % threshould
                A_set=(abs(H)>=H_th); % the set of frequencies whose channel gain is larger than a given threshould H_th
                N_A=sum(A_set,1); % the cardinality of A_set
                cor=sum( (Y./H) .* conj(S_dec) .* A_set,1)/N_A;
        end
            
        coreff=abs(cor)^2/(decision_pwr*signal_pwr);
        if (coreff>1)  % cap out to 1
            coreff=1;
        end
        
        K=(noise_pwr/signal_pwr)+(1-coreff)* H_sq;  %column 
        C=conj(H)./ K; % C is a diagonal matrix 
        beta=sum(C.*H,1)/sys_par.tblock;  % diag(matrix): column vector; H: row vector
        B=-cor/decision_pwr*(diag(C.*H)-beta*eye(sys_par.tblock));
        hc=beta; 
        C = diag(C);
        S_temp=C*Y+B*S_dec;
    end%end if (n==1)
    
    s_temp=ifft(S_temp).*sqrt(sys_par.tblock); % normalized
    s_temp = s_temp/hc; 
    S_temp = fft(s_temp,sys_par.tblock)/sqrt(sys_par.tblock);
    
    data_temp=s_temp(data.position); %remove TS
    pn_temp=s_temp(reshape(pilot.position.',1,[])); %TS
    
   
    %Symbol Slicing
    for ii=1:size(data.position,2)
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