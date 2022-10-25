function [BEM_MSE] = Theoretical_BEM_MSE(sys_par,fade_struct,snr,est_par,tx_par,rx_par,td_window,indv)
    
    BEM_MSE = zeros(1,size(indv.range,2));
    for kk = 1:size(indv.range,2)

        %Adjust Independent variable
        switch(indv.option) %adjust the independent variable
            case(1)
                snr.db = indv.range(kk);
                snr.noise_pwr = 10^(-snr.db/10);
            case(2)
                fade_struct.fd = indv.range(kk);
                fade_struct.nor_fd = fade_struct.fd/sys_par.tblock;
            case(3)
                rx_par.IBDFE.eta = indv.range(kk);
            case(4)
                est_par. l = indv.range(kk);
        end
        
        %initialization
        F = fft(eye(sys_par.tblock))/sqrt(sys_par.tblock); 

        [pilot,data,observation,contaminating_data,w,U,A] = SC_system_initialization(sys_par,tx_par,est_par,td_window,fade_struct);
        
        switch(est_par.type)
                case 1 %LS
                    channel_autocorrelation = besselj(0,(-(sys_par.tblock-1):(sys_par.tblock-1))*2*pi*fade_struct.nor_fd);
                    ch_ac_matrix = zeros(sys_par.tblock,sys_par.tblock);
                    for p = 1:sys_par.tblock
                        element_num = p;
                        ch_ac_matrix = ch_ac_matrix + diag(ones(1,element_num),-(p-sys_par.tblock))*channel_autocorrelation(p);
                    end
                    for p = sys_par.tblock+1:2*sys_par.tblock-1
                        element_num = 2*sys_par.tblock-p; 
                        ch_ac_matrix = ch_ac_matrix + diag(ones(1,element_num),-(p-sys_par.tblock))*channel_autocorrelation(p);
                    end

                    switch(fade_struct.ch_model)
                        case(3)
                            inv_nrms=1/fade_struct.nrms;
                            var0=((1-exp(-inv_nrms))/(1-exp(-fade_struct.ch_length*inv_nrms))); % c value
                            avg_pwr=var0*exp(-(0:fade_struct.ch_length-1)*inv_nrms);
                        case(4)
                            avg_pwr = 1/fade_struct.ch_length*ones(1,fade_struct.ch_length);
                    end
                    pseudo_U = (U'*U)\(U');
                    Rhl_normalized = pseudo_U*diag(w)*ch_ac_matrix*diag(w')*pseudo_U';
                    Rc = kron(Rhl_normalized,diag(avg_pwr));

                    Rd = zeros(observation.cluster_length*sys_par.G,observation.cluster_length*sys_par.G);%data interference correlation
                    X_position = pilot.start_index-sys_par.M+1+est_par.l;
                    X_position = X_position.';
                    X_position = X_position + kron(ones(sys_par.G,1),(0:sys_par.M-1));
                    X_position = mod(X_position-1,sys_par.tblock)+1;
                    for g = 1:sys_par.G
                        xg = X_position(g,:);
                        midproduct_1 = kron(eye(est_par.BEM.I),F(:,xg));
                        X = midproduct_1*Rc*midproduct_1';
                        Ug = [];
                        for I = 1:est_par.BEM.I
                            d_U = diag(U(:,I));
                            Ug = [Ug d_U(observation.position(g,:),observation.position(g,:))];
                        end
                        midproduct_2 = Ug*kron(eye(est_par.BEM.I),F(:,observation.position(g,:))');                    
                        midproduct_3 = F(:,[1:contaminating_data.oneside_length contaminating_data.oneside_length+sys_par.P+1+1:2*contaminating_data.oneside_length+sys_par.P+1]);
                        Rfcd = sys_par.tblock*(midproduct_3*midproduct_3');
                        midproduct_4 = midproduct_2*(kron(ones(est_par.BEM.I,est_par.BEM.I),Rfcd).*X)*midproduct_2';
                        Rd(observation.cluster_length*(g-1)+1:observation.cluster_length*g,observation.cluster_length*(g-1)+1:observation.cluster_length*g) = midproduct_4;
                    end

                    Rn = snr.noise_pwr*diag(w)*diag(w');
                    Rn = Rn(reshape(observation.position.',1,[]),reshape(observation.position.',1,[]));
                    RI = Rn + Rd;
                    
                    pseudo_A = (A'*A)\(A');
                    %pseudo_A = pinv(A_stacked);
                    %pseudo_A = A_stacked\eye(size(A_stacked,1));
                    MSE = abs(trace(pseudo_A*RI*pseudo_A'));

                case 2 %BLUE
                    MSE_BLUE = 0;
                    %By Monte Carlo Method
                    for ii = 1:tx_par.nblock                      
                        display(indv.str(indv.option)+' & block index '+num2str(indv.range(kk))+'_'+num2str(ii));

                        [h,h_taps] = gen_ch_imp(fade_struct, sys_par,ii); 
                        %[h,h_taps] = ZX_gen_ch_imp(fade_struct, sys_par,(ii-1)*(sys_par.tblock + fade_struct.ch_length));

                        %Window adapted
                        h = diag(w)*h; %each row with same gain;
                        h_taps = diag(w)*h_taps;
                        [h_approx,h_taps_approx,c] = BEM_approximation(h, fade_struct.ch_length, est_par.BEM.Q,est_par.BEM.type,w);

                        row_distance = size(observation.position,2);
                        column_distance = size(contaminating_data.position,2);
                        h_data_related = zeros(row_distance*sys_par.G,column_distance*sys_par.G);
                        for g = 1:sys_par.G
                            h_data_related((g-1)*row_distance+1:g*row_distance,(g-1)*column_distance+1:g*column_distance) = h_approx(observation.position(g,:),contaminating_data.position(g,:));
                        end

                        Rd = (h_data_related*h_data_related')*1;
                        Rn = snr.noise_pwr*diag(w)*diag(w');
                        Rn = Rn(reshape(observation.position.',1,[]),reshape(observation.position.',1,[]));
                        RI = Rn + Rd;
                        MSE_BLUE = MSE_BLUE + trace((A'/(RI)*A)\eye(size(A,2)));   
                    end   
                    MSE = MSE_BLUE/tx_par.nblock;
        end
        BEM_MSE(1,kk) = MSE;
    end

end