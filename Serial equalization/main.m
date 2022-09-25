
clear all;
clc;

%% Options(Channel Estimation & Detection)
DE_option.detection_on = 1;

%% System parameters(Frame structure)
sys_par.tblock = 128; %Blocksize
sys_par.M = 5;%CP length + 1: M
sys_par.pilot_random_seed = 0;
sys_par.pilot_scheme = 1;
sys_par.random_seed = 0;
sys_par.ndata = sys_par.tblock;  % Number of data symbols

%% SNR parameters(Noise) 雜訊
snr.db = 10;
snr.noise_pwr=10^(-snr.db/10);

%% Channel parameters 通道參數
fade_struct.ch_length = sys_par.M;
fade_struct.fading_flag=1;
fade_struct.ch_model=3;
fade_struct.nrms = 10;

fade_struct.fd = 0.3;% Doppler frequency
fade_struct.nor_fd = fade_struct.fd/sys_par.tblock;

%% Tx parameters 傳送端參數
tx_par.mod_type_str={'BPSK','QPSK','16QAM','64QAM'};
tx_par.mod_type = 2; % 1: BPSK
                     % 2: QPSK
                     % 3: 16QAM
                   
tx_par.mod_nbits_per_sym = [1 2 4 6]; % bit of mod type
tx_par.nbits_per_sym = tx_par.mod_nbits_per_sym(tx_par.mod_type);
tx_par.pts_mod_const=2^(tx_par.nbits_per_sym); % points in modulation constellation

tx_par.nblock= 10; % Number of transmitted blocks

%% Rx parameter 接收端參數

rx_par.type_str={
    'Serial equalation MMES'
    'Serial equalization DFE'
    };
rx_par.type = 1;
rx_par.K = [1 5 15 25];

%% Independent variable 控制變因
indv.str = ["SNR(Es/No)","fd","Serial Equalization K"];
indv.option = 1;
indv.range = 1:30;
%% Dependent variable 應變變因
%BER,SER
dv.BER = zeros(size(rx_par.K,2),size(indv.range,2));
dv.SER = zeros(size(rx_par.K,2),size(indv.range,2));



%% initialization
trans_block=zeros(1,sys_par.tblock); % transmission (constellation) block
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
            rx_par.K = indv.range(kk);
    end
    
    %Set random seed
    rand('state',sys_par.random_seed);
    randn('state',sys_par.random_seed);
    dv.bit_error_count = zeros(size(dv.BER,1),1);
    dv.sym_error_count = zeros(size(dv.SER,1),1);
    display(indv.str(indv.option)+num2str(indv.range(kk)));
    for ii=1:tx_par.nblock
        
        trans_block=zeros(1,sys_par.tblock); % transmission (constellation) block
        [data.const_data data.dec_data data.bit_data]=block_sym_mapping(sys_par.ndata,tx_par);% generate data block
        trans_data = data.const_data;
        trans_block = ifft(trans_data,sys_par.tblock)*sqrt(sys_par.tblock);     % OFDM
        trans_block = trans_block.';%column vector
        
        noise_block = sqrt(snr.noise_pwr/2)*(randn(1,sys_par.tblock)+1j*randn(1,sys_par.tblock));
        noise_block = noise_block.';%column vector
        
        [h,h_taps] = gen_ch_imp(fade_struct, sys_par,ii);
        
        %trans_block_FD = fft(trans_block,sys_par.tblock)/sqrt(sys_par.tblock);%column vector
        %noise_block_FD=fft(noise_block,sys_par.tblock)/sqrt(sys_par.tblock); %column vector
        
        y = h*trans_block + noise_block;
        Y = fft(y,sys_par.tblock)/sqrt(sys_par.tblock); %column vector
        %H_est = fft(h,sys_par.tblock)*ifft(eye(sys_par.tblock),sys_par.tblock);
        H = dftmtx(128)*h*conj(dftmtx(128))/128;
        
        %Detection...
        if(DE_option.detection_on ==1)
            
            switch(rx_par.type)
                case(1) % Serial equalation MMES 
                     for i=1:size(rx_par.K,2)
                        K = rx_par.K(i);
                        [data.hat_dec(i,:) data.hat_bit(i,:)] = SE_MMSE(sys_par,tx_par,K,H,Y,snr.noise_pwr,data);
                     end
                case(2) % Serial equalization DFE 
                     [data.hat_dec data.hat_bit] = SE_DFE(sys_par,tx_par,rx_par,H,Y,snr.noise_pwr,data);
            end% end rx_par.type

            dv.sym_error_count(:,1) = dv.sym_error_count(:,1) + sum((data.hat_dec-data.dec_data)~=0,2);
            dv.bit_error_count(:,1) = dv.bit_error_count(:,1) + sum((data.hat_bit-data.bit_data)~=0,2);
        end
    end % end ii=1:tx_par.nblock
    
    dv.SER(:,kk) = dv.sym_error_count/(tx_par.nblock*sys_par.ndata);
    dv.BER(:,kk) = dv.bit_error_count/(tx_par.nblock*sys_par.ndata*tx_par.nbits_per_sym);

        
        
end
    
semilogy(indv.range,dv.BER(1,:),'-d');
xlabel('SNR');
ylabel('BER');
grid on;
hold on;
semilogy(indv.range,dv.BER(2,:),'-^');
semilogy(indv.range,dv.BER(3,:),'-*');
semilogy(indv.range,dv.BER(4,:),'-o');
legend('1 tap MMSE','5 tap MMSE','15 tap MMSE','25 tap MMSE')


