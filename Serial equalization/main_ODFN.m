
clear all;
clc;

%% Options(Channel Estimation & Detection)
DE_option.detection_on = 1;

%% System parameters(Frame structure)
sys_par.tblock = 128;   %Blocksize
sys_par.M = sys_par.tblock/8;   %CP length + 1: M
sys_par.pilot_random_seed = 0;
sys_par.pilot_scheme = 1;
sys_par.random_seed = 0;
sys_par.ndata = sys_par.tblock;  % Number of data symbols
sys_par.type_str = {'SC','OFDM'};
sys_par.type = 2;


%% SNR parameters(Noise) 馒癟
snr.db = 10;
snr.noise_pwr=10^(-snr.db/10);
snr.type = 1;
snr.type_str={'Es_N0','Eb_N0'};

%% Channel parameters 硄笵把计
fade_struct.ch_length = sys_par.M;
fade_struct.fading_flag=1;
fade_struct.ch_model_str={'slow fading exponential PDP','slow fading uniform PDP','fast fading exponential PDP','fast fading uniform PDP','Two_path_ch','Tang_ch'};
fade_struct.ch_model=5;
fade_struct.nrms = 10;

%fade_struct.fd = 0.3;% Doppler frequency
%fade_struct.nor_fd = fade_struct.fd/sys_par.tblock;
fade_struct.nor_fd = 0.004;
fade_struct.fd = fade_struct.nor_fd*sys_par.tblock;



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
    };
rx_par.type = 1;

rx_par.K = [5];


%% Window 把计
window_par.type_str={'no window','Tang window'};
window_par.type = 1;

%% Independent variable 北跑
indv.str = ["SNR(Es/No)","fd","Serial Equalization K"];
indv.option = 1;
indv.range = 0:5:30;
%% Dependent variable 莱跑跑
%BER,SER
dv.BER = zeros(size(rx_par.K,2),size(indv.range,2));
dv.SER = zeros(size(rx_par.K,2),size(indv.range,2));

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
            switch(indv.option)
                case(1) %Es/N0
                    snr.noise_pwr = 1/snr.snr;
                case(2) %Eb/N0
                    snr.noise_pwr = 1/tx_par.nbits_per_sym/snr.snr; 
            end
        case(2)
            fade_struct.fd = indv.range(kk);
            fade_struct.nor_fd = fade_struct.fd/sys_par.tblock;
        case(3)
            rx_par.K = indv.range(kk);
    end
    
    %Set random seed
    rand('state',sys_par.random_seed);
    randn('state',sys_par.random_seed);
    dv.bit_error_count = zeros(size(dv.BER,1),1);
    dv.sym_error_count = zeros(size(dv.SER,1),1);
    display(indv.str(indv.option)+num2str(indv.range(kk)));
    
    switch(window_par.type)
        case(1)
            w = ones(1,sys_par.tblock);
        case(2)
            [w]=Tang_ODM_window(sys_par,rx_par,fade_struct,snr,4);
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
        %noise_block = sqrt(snr.noise_pwr)*randn(1,sys_par.tblock);    % Noise for BPSK
        noise_block = noise_block.';%column vector
        
        [h,h_taps] = gen_ch_imp(fade_struct, sys_par,ii);
        
        %trans_block_FD = fft(trans_block,sys_par.tblock)/sqrt(sys_par.tblock);%column vector
        %noise_block_FD=fft(noise_block,sys_par.tblock)/sqrt(sys_par.tblock); %column vector
        
        % Window
        
        y = h*trans_block + noise_block;
        y = diag(w)*y;
        Y = fft(y,sys_par.tblock)/sqrt(sys_par.tblock); %column vector
        H = fft(diag(w)*h,sys_par.tblock)*ifft(eye(sys_par.tblock),sys_par.tblock);
        %figure(1)
        %pcolor(flip(abs(H)));
        %colorbar
        %H2 = fft(h,sys_par.tblock)*ifft(eye(sys_par.tblock),sys_par.tblock);
       
   
        %H = dftmtx(128)*h*conj(dftmtx(128))/128;
        
        %Detection...
        if(DE_option.detection_on ==1)
            
            switch(rx_par.type)
                case(1) % Serial equalation MMES 
                     for i=1:size(rx_par.K,2)
                        K = rx_par.K(i);
                        [data.hat_dec(i,:) data.hat_bit(i,:)] = SE_MMSE(sys_par,tx_par,K,H,Y,snr.noise_pwr,data,w);
                     end
                case(2) % Serial equalization DFE 
                     for i=1:size(rx_par.K,2)
                        K = rx_par.K(i);
                        [data.hat_dec(i,:) data.hat_bit(i,:)] = SE_DFE(sys_par,tx_par,K,H,Y,snr.noise_pwr,data,w);
                     end
            end

            dv.sym_error_count(:,1) = dv.sym_error_count(:,1) + sum((data.hat_dec-data.dec_data)~=0,2);
            dv.bit_error_count(:,1) = dv.bit_error_count(:,1) + sum((data.hat_bit-data.bit_data)~=0,2);
        end
    end % end ii=1:tx_par.nblock
    
    dv.SER(:,kk) = dv.sym_error_count/(tx_par.nblock*sys_par.ndata);
    dv.BER(:,kk) = dv.bit_error_count/(tx_par.nblock*sys_par.ndata*tx_par.nbits_per_sym);

        
        
end
    
semilogy(indv.range,dv.SER(1,:),'-d');
xlabel('SNR');
ylabel('BER');
grid on;
hold on;
%semilogy(indv.range,dv.BER(2,:),'-^');
%semilogy(indv.range,dv.BER(3,:),'-*');
%semilogy(indv.range,dv.BER(4,:),'-o');
%legend('1 tap MMSE','5 tap MMSE','25 tap MMSE')


%save(filename,'indv','dv','sys_par','tx_par','rx_par','snr','fade_struct');
