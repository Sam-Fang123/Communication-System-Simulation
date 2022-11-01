
clear all;
clc;

%% Options(Channel Estimation & Detection)
DE_option.detection_on = 1;

%% System parameters(Frame structure)
sys_par.tblock = 128;   %Blocksize
sys_par.M = 5;   %CP length + 1: M
sys_par.pilot_random_seed = 0;
sys_par.pilot_scheme = 1;
sys_par.random_seed = 0;
sys_par.ndata = sys_par.tblock;  % Number of data symbols
sys_par.type_str = {'SC','OFDM'};
sys_par.type = 1;


%% SNR parameters(Noise) 馒癟
snr.db = 10;
snr.noise_pwr=10^(-snr.db/10);
snr.type = 1;
snr.type_str={'Es_N0','Eb_N0'};

%% Channel parameters 硄笵把计
fade_struct.ch_length = sys_par.M;
fade_struct.fading_flag=1;
fade_struct.ch_model_str={'slow fading exponential PDP','slow fading uniform PDP','fast fading exponential PDP','fast fading uniform PDP','Two_path_ch','Tang_ch'};
fade_struct.ch_model=3;
fade_struct.nrms = 10;

fade_struct.fd = 0.3;% Doppler frequency
fade_struct.nor_fd = fade_struct.fd/sys_par.tblock;
%fade_struct.nor_fd = 0.004;
%fade_struct.fd = fade_struct.nor_fd*sys_par.tblock;



%% Tx parameters 肚癳狠把计
tx_par.mod_type_str={'BPSK','QPSK','16QAM','64QAM'};
tx_par.mod_type = 2; % 1: BPSK
                     % 2: QPSK
                     % 3: 16QAM
                   
tx_par.mod_nbits_per_sym = [1 2 4 6]; % bit of mod type
tx_par.nbits_per_sym = tx_par.mod_nbits_per_sym(tx_par.mod_type);
tx_par.pts_mod_const=2^(tx_par.nbits_per_sym); % points in modulation constellation

tx_par.nblock= 10; % Number of transmitted blocks

%% Rx parameter 钡Μ狠把计

rx_par.type_str={
    'SE_MMES'   % Only for OFDM
    'SE_DFE'    % Only for OFDM
    'IBDFE_TV_T3C1'; %3 Correlation Estimator Type
    'IBDFE_TV_T2C1_Quasibanded'
    };
rx_par.type = 4;
if(sys_par.type==1&&(rx_par.type==2||rx_par.type==1))
    error("serial equalization only for OFDM")
elseif(sys_par.type==2&&rx_par.type==3)
    error("IBDFE only for Single carrier")
elseif(sys_par.type==2&&rx_par.type==4)
    error("IBDFE only for Single carrier")
end
rx_par.SE.K = [1 5 11 25];
rx_par.IBDFE.cor_type_str={'GA cor','EST cor td', 'EST cor fd', 'TI cor_noth', 'TI cor_th'};% correlation coefficient
rx_par.IBDFE.cor_type = 3;
rx_par.IBDFE.eta = 1;%For and Correlation Estimator using TS(type 2) and type 3
rx_par.IBDFE.D_type = [0 2 8 10];%For IBDFE T3C1 and T2C1_Quasibanded
rx_par.IBDFE.first_iteration_full = 1;%For IBDFE T1C1, T3C1 ==> 1: use full block MMSE for first iteration
%Parameter for iterative equalizer;
rx_par.iteration = 4;
data.position = 1:sys_par.tblock;
pilot.position = 0;

%% Window 把计
window_par.type_str={'no_window','Tang_window_ODM'};
window_par.type = 1;
window_par.Q = 4;
window_par.banded_str = {'Banded','Not banded'};
window_par.banded = 1;

if(window_par.type==2&&window_par.banded==2)
    error("Tang's window should use banded channel");
elseif(rx_par.type==3&&window_par.banded==1)
    error("IBDFE-T3C1 should not use banded matrix")
elseif(rx_par.type==4&&window_par.type==1&&window_par.banded==1)
    error("IBDFE-T2C1 without window should not be banded channel")
end

%% Independent variable 北跑
indv.str = ["SNR(Es/No)","fd","Serial Equalization K"];
indv.option = 1;
indv.range = 0:4:24;
%% Dependent variable 莱跑跑
%BER,SER
if(rx_par.type==1||rx_par.type==2)
    dv.BER = zeros(size(rx_par.SE.K,2),size(indv.range,2));
    dv.SER = zeros(size(rx_par.SE.K,2),size(indv.range,2));
elseif(rx_par.type==3||rx_par.type==4)
    dv.BER = zeros(size(rx_par.IBDFE.D_type,2),size(indv.range,2));
    dv.SER = zeros(size(rx_par.IBDFE.D_type,2),size(indv.range,2));
end

filename = "";
filename = filename + sys_par.type_str(sys_par.type);
filename = filename + "_"+ rx_par.type_str(rx_par.type);
filename = filename + "_" + tx_par.mod_type_str(tx_par.mod_type);
filename = filename + "_" + fade_struct.ch_model_str(fade_struct.ch_model);
filename = filename + "_ch_num=" + num2str(sys_par.M);
filename = filename + "_fd=" + num2str(fade_struct.fd);
filename = filename + "_Nblock=" + num2str(tx_par.nblock);
filename = filename + "_snr=" + snr.type_str(snr.type);
filename = filename + "_window=" + window_par.type_str(window_par.type);
%filename = filename + "_Q=" + num2str(window_par.Q);
filename = filename + "_" + window_par.banded_str(window_par.banded);
filename = filename + ".mat";
filename

%% initialization
trans_block=zeros(1,sys_par.tblock); % transmission (constellation) block
for kk = 1:size(indv.range,2)
    
    %Adjust Independent variable
    switch(indv.option) %adjust the independent variable
        case(1)
            snr.db = indv.range(kk);
            snr.snr = 10^(snr.db/10);
            switch(snr.type)
                case(1) %Es/N0
                    snr.noise_pwr = 1/snr.snr;
                case(2) %Eb/N0
                    snr.noise_pwr = 1/tx_par.nbits_per_sym/snr.snr; 
            end
        case(2)
            fade_struct.fd = indv.range(kk);
            fade_struct.nor_fd = fade_struct.fd/sys_par.tblock;
        case(3)
            rx_par.SE.K = indv.range(kk);
    end
    
    %Set random seed
    rand('state',sys_par.random_seed);
    randn('state',sys_par.random_seed);
    dv.bit_error_count = zeros(size(dv.BER,1),1);
    dv.sym_error_count = zeros(size(dv.SER,1),1);
    display(indv.str(indv.option)+num2str(indv.range(kk)));
    
    switch(window_par.type)
        case(1)
            w.w = ones(1,sys_par.tblock);
            w.FD_mtx = eye(sys_par.tblock);
        case(2)
            [w.w w.FD_mtx]=Tang_window(sys_par,rx_par,fade_struct,snr,window_par.Q,window_par); 
    end
 
    
    for ii=1:tx_par.nblock
        
        trans_block=zeros(1,sys_par.tblock); % transmission (constellation) block
        [data.const_data data.dec_data data.bit_data]=block_sym_mapping(sys_par.ndata,tx_par);% generate data block
        trans_block = data.const_data;
        if(sys_par.type==2) % OFDM
            trans_block = ifft(trans_block,sys_par.tblock)*sqrt(sys_par.tblock);     
        end
        trans_block = trans_block.';%column vector
        
        noise_block = sqrt(snr.noise_pwr/2)*(randn(1,sys_par.tblock)+1j*randn(1,sys_par.tblock));
        
        noise_block = noise_block.';%column vector
        
        [h,h_taps] = gen_ch_imp(fade_struct, sys_par,ii);
        

        % Window
        y = h*trans_block + noise_block;
        y = diag(w.w)*y;
        Y = fft(y,sys_par.tblock)/sqrt(sys_par.tblock); %column vector
        H = fft(diag(w.w)*h,sys_par.tblock)*ifft(eye(sys_par.tblock),sys_par.tblock);
        
        if(window_par.banded==1)
            % Banded matrix
            B_mtx = zeros(sys_par.tblock,sys_par.tblock);
            for k=0:sys_par.tblock-1
                rho = mod(k-window_par.Q/2-1+(1:window_par.Q+1),sys_par.tblock)+1;
                B_mtx(rho,k+1) = 1;
            end
            H = H.*B_mtx;
        end
        
        %Detection...
        if(DE_option.detection_on ==1)
            
            switch(rx_par.type)
                case(1) % Serial equalation MMES 
                     for i=1:size(rx_par.SE.K,2)
                        K = rx_par.SE.K(i);
                        [data.hat_dec(i,:) data.hat_bit(i,:)] = SE_MMSE(sys_par,tx_par,K,H,Y,snr.noise_pwr,data,w);
                     end
                case(2) % Serial equalization DFE 
                     for i=1:size(rx_par.SE.K,2)
                        K = rx_par.SE.K(i);
                        [data.hat_dec(i,:) data.hat_bit(i,:)] = SE_DFE(sys_par,tx_par,K,H,Y,snr.noise_pwr,data,w);  
                     end
                case(3) %IBDFE_TV_T3C1
                    for i = 1:size(rx_par.IBDFE.D_type,2)
                        rx_par.IBDFE.D = rx_par.IBDFE.D_type(i);
                        [data.hat_dec(i,:) data.hat_bit(i,:)]=IBDFE_TV_T3C1(sys_par,tx_par,rx_par,H,Y,snr.noise_pwr,pilot,data,w.w);
                    end
                case(4) %IBDFE_TV_T2C1_Quasibanded
                    for i = 1:size(rx_par.IBDFE.D_type,2)
                        rx_par.IBDFE.D = rx_par.IBDFE.D_type(i);
                        [data.hat_dec(i,:) data.hat_bit(i,:)]=IBDFE_TV_T2C1_Quasibanded(sys_par,tx_par,rx_par,H,Y,snr.noise_pwr,pilot,data,w.w);
                    end
                end
           

            dv.sym_error_count(:,1) = dv.sym_error_count(:,1) + sum((data.hat_dec-data.dec_data)~=0,2);
            dv.bit_error_count(:,1) = dv.bit_error_count(:,1) + sum((data.hat_bit-data.bit_data)~=0,2);
        end
    end % end ii=1:tx_par.nblock
    
    dv.SER(:,kk) = dv.sym_error_count/(tx_par.nblock*sys_par.ndata);
    dv.BER(:,kk) = dv.bit_error_count/(tx_par.nblock*sys_par.ndata*tx_par.nbits_per_sym);
end
  

figure(1)
semilogy(indv.range,dv.BER(1,:),'-d');
xlabel('SNR');
ylabel('BER');
grid on;
hold on;
semilogy(indv.range,dv.BER(2,:),'-^');
semilogy(indv.range,dv.BER(3,:),'-*');
semilogy(indv.range,dv.BER(4,:),'-o');
legend('1 tap MMSE','5 tap MMSE','11 tap MMSE','25 tap MMSE');


%save(filename,'indv','dv','sys_par','tx_par','rx_par','snr','fade_struct');
