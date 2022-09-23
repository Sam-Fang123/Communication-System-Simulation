
clear all;
clc;

%% Options(Channel Estimation & Detection)
DE_option.estimation_on = 1;
DE_option.detection_on = 0;

%% System parameters(Frame structure)
sys_par.tblock = 128; %Blocksize
sys_par.M = 5;%CP length + 1: M
sys_par.pilot_random_seed = 0;
sys_par.pilot_scheme = 1;
sys_par.random_seed = 0;
sys_par.ndata = sys_par.tblock  % Number of data symbols

%% SNR parameters(Noise) 雜訊
snr.db = 10;
snr.noise_pwr=10^(-snr.db/10);

%% Channel parameters 通道參數
fade_struct.ch_length = sys_par.M;
fade_struct.fading_flag=1;
fade_struct.ch_model=3;
fade_struct.nrms = 10;

fade_struct.fd = 0.2;% Doppler frequency
fade_struct.nor_fd = fade_struct.fd/sys_par.tblock;

%% Tx parameters 傳送端參數
tx_par.mod_type_str={'BPSK','QPSK','16QAM','64QAM'};
tx_par.mod_type = 2; % 1: BPSK
                     % 2: QPSK
                     % 3: 16QAM
                   
tx_par.mod_nbits_per_sym = [1 2 4 6]; % bit of mod type
tx_par.nbits_per_sym = tx_par.mod_nbits_per_sym(tx_par.mod_type);
tx_par.pts_mod_const=2^(tx_par.nbits_per_sym); % points in modulation constellation

tx_par.nblock= 1; % Number of transmitted blocks

%% Rx parameter 接收端參數

rx_par.type_str={
    'Serial equalation MMES'
    'Serial equalization DFE'
    };
rx_par.type = 1;
rx_par.K = 5;

%% Independent variable 控制變因
indv.str = ["SNR(Es/No)","fd","Serial Equalization K"];
indv.option = 1;
indv.range = 1:30;
%% Dependent variable 應變變因
%BER,SER
dv.BER = zeros(1,size(indv.range,2));
dv.SER = zeros(1,size(indv.range,2));



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
    for ii=1:tx_par.nblock
        
        display(indv.str(indv.option)+' & block index  '+num2str(indv.range(kk))+'_'+num2str(ii));
        
        [data.const_data data.dec_data data.bit_data]=block_sym_mapping(sys_par.ndata,tx_par);% generate data block
    end
end
    
    
