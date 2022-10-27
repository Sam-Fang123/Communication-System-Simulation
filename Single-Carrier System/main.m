%%Single Carrier System Adopting Basis Expansion Model
%%2022/5/6 by Yi Cheng Lin
%Assume signal power=1, channel total power = 1
clc;
clear all;
tic; %timer
%% Options(Channel Estimation & Detection)
DE_option.estimation_on = 0;
DE_option.detection_on = 1;
DE_option.type = DE_option.estimation_on + DE_option.detection_on*2;
%Type 0: Not Working
%Type 1: Estimation Mode(No Detection)
%Type 2: Detection Mode(Assume Perfect Channel Estimation, No Channel Estimation)
%Type 3: Channel Estimation And Detection Both Working
%% Time Domain Window parameter 時域視窗濾波器
td_window.str = ["No-windowing","MBAE-SOE","Tang"];
td_window.type =3;
td_window.Q = 4;
%% System parameters(Frame structure)
sys_par.tblock = 256; %Blocksize
sys_par.P = 14;%pilot cluster length: P+1, P is even
sys_par.G = 6;%cluster number: G
sys_par.M = 5;%CP length + 1: M
sys_par.nts = sys_par.G*(sys_par.P+1); %Number of total pilot symbols
sys_par.ndata = sys_par.tblock - sys_par.nts; % Number of data symbols
sys_par.bandwidth_efficiency = sys_par.ndata/sys_par.tblock*100;
sys_par.pilot_shift = 15;
sys_par.pilot_random_seed = 0;
sys_par.pilot_scheme = 1;
sys_par.random_seed = 0;
%% Channel parameters 通道參數
fade_struct.ch_length = sys_par.M;
fade_struct.fading_flag=1;
fade_struct.ch_model=3;
fade_struct.nrms = 10;

fade_struct.fd = 0.2;% Doppler frequency
fade_struct.nor_fd = fade_struct.fd/sys_par.tblock;
%% SNR parameters(Noise) 雜訊
snr.db = 10;
snr.noise_pwr=10^(-snr.db/10);
%% Channel Estimator parameters(BEM) 通道估測
est_par.type_str = {'LS','BLUE'};
est_par.type = 1;

est_par.BEM.str = ["CE-BEM","GCE-BEM","P-BEM"];
est_par.BEM.typenum = size(est_par.BEM.str,2);
est_par.BEM.type = 2;
est_par.BEM.I = 5;  %bases number 
est_par.BEM.Q = floor(est_par.BEM.I/2);

est_par.l = 4;%parameter l determines the range of observation vector used for channel estimation(l>=0, l<=(P+M-1)/2 for SC system);
est_par.BLUE_iterative_times = 5;

est_par.plot_taps = 1;%plot the taps or not
est_par.plot_taps_blockindex = 1;
%% Tx parameters 傳送端參數
tx_par.mod_type_str={'BPSK','QPSK','16QAM','64QAM'};
tx_par.mod_type = 2; % 1: BPSK
                     % 2: QPSK
                     % 3: 16QAM
                   
tx_par.mod_nbits_per_sym = [1 2 4 6]; % bit of mod type
tx_par.nbits_per_sym = tx_par.mod_nbits_per_sym(tx_par.mod_type);
tx_par.pts_mod_const=2^(tx_par.nbits_per_sym); % points in modulation constellation

tx_par.nblock= 100; % Number of transmitted blocks
%% Rx parameter 接收端參數
% IBDFE (Scaling Factor removed and divide beta before slicing)
rx_par.type_str={
    'IBDFE_TV_T1C1';%3 Correlation Estimator Type
    'IBDFE_TV_T1C1(Ideal Feedback)';
   
    'IBDFE_TV_T2C1';%3 Correlation Estimator Type
    'IBDFE_TV_T2C1(Ideal Feedback)';
    
    'IBDFE_TV_T2C1_Quasibanded';%3 Correlation Estimator Type
    'IBDFE_TV_T2C1_Qusibanded(Ideal Feedback)';
    
    'IBDFE_TV_T3C1';%3 Correlation Estimator Type
    'IBDFE_TV_T3C1(Ideal Feedback)';
    
    'IBDFE_TI';%5 Correlation Estimator Type
    };
rx_par.type = 7;

%{
Parameters for IBDFE ==> 
Correlation Type for IBDFE_TV_T1C1: 1.Genie-Aided 2.TS 3.Proposed
Correlation Type for IBDFE_TV_T2C1: 1.Genie-Aided 2.TS 3.Proposed
Correlation Type for IBDFE_TV_T3C1: 1.Genie-Aided 2.TS 3.Proposed
Correlation Type for IBDFE_TI: 1.Genie-Aided 2.TS 3.Proposed 4.Original
                               5.Tomasin with Threshold
%}
rx_par.IBDFE.cor_type_str={'GA cor','EST cor td', 'EST cor fd', 'TI cor_noth', 'TI cor_th'};% correlation coefficient
rx_par.IBDFE.cor_type = 3;
rx_par.IBDFE.eta = 1;%For and Correlation Estimator using TS(type 2) and type 3
rx_par.IBDFE.D = 2;%For IBDFE T3C1 and T2C1_Quasibanded
rx_par.IBDFE.first_iteration_full = 1;%For IBDFE T1C1, T3C1 ==> 1: use full block MMSE for first iteration

%Parameter for iterative equalizer;
rx_par.iteration = 4;
%% Independent variable 控制變因
indv.str = ["SNR(Es/No)","fd","IBDFE's eta","observation parameter l"];
indv.option = 1;
indv.range = 0:4:20;
%% Dependent variable 應變變因
%BER,SER
if(rx_par.type == 2||rx_par.type == 4||rx_par.type == 6)%Ideal case ==> No Iteration
    dv.BER = zeros(1,size(indv.range,2));
    dv.SER = zeros(1,size(indv.range,2));
else
    dv.BER = zeros(rx_par.iteration,size(indv.range,2));
    dv.SER = zeros(rx_par.iteration,size(indv.range,2));
end

%MSE
dv.BEM_MSE = zeros(1,size(indv.range,2));
dv.CH_MSE = zeros(1,size(indv.range,2));
dv.Theory_BEM_MSE = zeros(1,size(indv.range,2));
%% initialization
trans_block=zeros(1,sys_par.tblock); % transmission (constellation) block
for kk = 1:size(indv.range,2)
    indv.range(kk)
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
                est_par.l = indv.range(kk);
    end
    
    %initialization
    [pilot,data,observation,contaminating_data,w,U,A] = SC_system_initialization(sys_par,tx_par,est_par,td_window,fade_struct);
   
    %Set random seed
    rand('state',sys_par.random_seed);
    randn('state',sys_par.random_seed);
    dv.bit_error_count = zeros(size(dv.BER,1),1);
    dv.sym_error_count = zeros(size(dv.SER,1),1);
    dv.BEM_MSE_count = 0;
    dv.CH_MSE_count = 0;
    
    re = zeros(sys_par.tblock,sys_par.tblock);
    for ii=1:tx_par.nblock
        
        %display(indv.str(indv.option)+' & block index  '+num2str(indv.range(kk))+'_'+num2str(ii));
        
        [data.const_data data.dec_data data.bit_data]=block_sym_mapping(sys_par.ndata,tx_par);% generate data block
        trans_block = zeros(1,sys_par.tblock);
        trans_block(reshape(pilot.position.',1,[])) = reshape(pilot.clusters_symbol.',1,[]);
        trans_block(data.position) = data.const_data;
        trans_block = trans_block.';%column vector
        
        noise_block=sqrt(snr.noise_pwr/2)*(randn(1,sys_par.tblock)+1j*randn(1,sys_par.tblock));
        noise_block = noise_block.';%column vector
        
        [h,h_taps] = gen_ch_imp(fade_struct, sys_par,ii);
        %[h,h_taps] = ZX_gen_ch_imp(fade_struct, sys_par,(ii-1)*(sys_par.tblock + fade_struct.ch_length));
        h = diag(w)*h;
        h_taps = diag(w)*h_taps;
        
        noise_block = diag(w)*noise_block;
        
        trans_block_FD = fft(trans_block,sys_par.tblock)/sqrt(sys_par.tblock);%column vector
        
        %H = fft(h,sys_par.tblock)*ifft(eye(sys_par.tblock),sys_par.tblock); %column vector
        noise_block_FD=fft(noise_block,sys_par.tblock)/sqrt(sys_par.tblock); %column vector
        
        y = h*trans_block + noise_block;
        Y = fft(y,sys_par.tblock)/sqrt(sys_par.tblock); %column vector
       
    
        %Channel Estimation...
        if(DE_option.estimation_on == 1)
            
            y_O = y(reshape(observation.position.',1,[]));
            switch(est_par.type)
                case(1)%LS
                    [h_est, h_taps_est, c_est] = Estimator_LS(sys_par,A,y_O,U);
                case(2)%Iterative BLUE
                    [h_est, h_taps_est, c_est] = Estimator_Iterative_BLUE(sys_par,A,y_O,snr.noise_pwr,observation,contaminating_data,est_par,U,w);
            end
            dv.CH_MSE_count = dv.CH_MSE_count + trace((h_taps_est - h_taps)*(h_taps_est - h_taps)');
            [h_approx,h_taps_approx,c] = BEM_approximation(h, fade_struct.ch_length, est_par.BEM.Q,est_par.BEM.type,w);
            dv.BEM_MSE_count = dv.BEM_MSE_count + trace((c_est - c)*(c_est-c)');
            %dv.BEM_MSE_count = dv.BEM_MSE_count + trace((h_taps_est - h_taps_approx)*(h_taps_est - h_taps_approx)');
        
            H_est = fft(h_est,sys_par.tblock)*ifft(eye(sys_par.tblock),sys_par.tblock);  
            
            %plot taps
            if(est_par.plot_taps == 1 && ii == est_par.plot_taps_blockindex)
                plot_BEM_estimated_channel(sys_par,h_taps,h_taps_est,h_taps_approx);
                sgtitle(est_par.BEM.str(est_par.BEM.type) + " by " + est_par.type_str(est_par.type) + " Estimator ( fd = " + num2str(fade_struct.fd) + ", SNR = "+ num2str(snr.db) + ", \gamma = "+num2str(est_par.l)+" )");
            end
        else
            H_est = fft(h,sys_par.tblock)*ifft(eye(sys_par.tblock),sys_par.tblock);
        end
        
        %Detection...
        if(DE_option.detection_on ==1)
            
            switch(rx_par.type)
                case(1) %IBDFE_TV_T1C1
                    [data.hat_dec data.hat_bit]=IBDFE_TV_T1C1(sys_par,tx_par,rx_par,H_est,Y,snr.noise_pwr,pilot,data,w);
                case(2) %IBDFE_TV_T1C1(Ideal Feedback)
                    [data.hat_dec data.hat_bit]=IBDFE_TV_T1C1_Ideal(sys_par,tx_par,H_est,Y,trans_block_FD,snr.noise_pwr,pilot,data,w);
                case(3) %IBDFE_TV_T2C1
                    [data.hat_dec data.hat_bit]=IBDFE_TV_T2C1(sys_par,tx_par,rx_par,H_est,Y,snr.noise_pwr,pilot,data,w);
                case(4) %IBDFE_TV_T2C1(Ideal Feedback)
                    [data.hat_dec data.hat_bit]=IBDFE_TV_T2C1_Ideal(sys_par,tx_par,H_est,Y,trans_block_FD,snr.noise_pwr,pilot,data,w);      
                case(5) %IBDFE_TV_T2C1_Quasibanded
                    [data.hat_dec data.hat_bit] = IBDFE_TV_T2C1_Quasibanded(sys_par,tx_par,rx_par,H_est,Y,snr.noise_pwr,pilot,data,w);
                case(6) %IBDFE_TV_T2C1_Quasibanded(Ideal Feedback)
                    [data.hat_dec data.hat_bit]=IBDFE_TV_T2C1_Quasibanded_Ideal(sys_par,tx_par,rx_par,H_est,Y,trans_block_FD,snr.noise_pwr,pilot,data,w);
                case(7) %IBDFE_TV_T3C1
                    [data.hat_dec data.hat_bit]=IBDFE_TV_T3C1(sys_par,tx_par,rx_par,H_est,Y,snr.noise_pwr,pilot,data,w);
                case(8) %IBDFE_TV_T3C1(Ideal Feedback)
                    [data.hat_dec data.hat_bit]=IBDFE_TV_T3C1_Ideal(sys_par,tx_par,rx_par,H_est,Y,trans_block_FD,snr.noise_pwr,pilot,data,w);
                case(9) %IBDFE_TI
                     [data.hat_dec data.hat_bit] = IBDFE_TI(sys_par,tx_par,rx_par,H_est,Y,snr.noise_pwr,pilot,data,w);
            end% end rx_par.type

            dv.sym_error_count(:,1) = dv.sym_error_count(:,1) + sum((data.hat_dec-data.dec_data)~=0,2);
            dv.bit_error_count(:,1) = dv.bit_error_count(:,1) + sum((data.hat_bit-data.bit_data)~=0,2);
        end
    end % end ii=1:tx_par.nblock
    
    dv.SER(:,kk) = dv.sym_error_count/(tx_par.nblock*sys_par.ndata);
    dv.BER(:,kk) = dv.bit_error_count/(tx_par.nblock*sys_par.ndata*tx_par.nbits_per_sym);
    
    dv.BEM_MSE(1,kk) = dv.BEM_MSE_count/tx_par.nblock;
    dv.CH_MSE(1,kk) = dv.CH_MSE_count/tx_par.nblock;
end% end kk = 1:size(indv.range,2);
% execution time
run_time.total=fix(toc/60); % unit: minute
run_time.hour=fix(run_time.total/60);
run_time.min=run_time.total-run_time.hour*60;
dv.run_time_str=[num2str(run_time.hour) ' hours and ' num2str(run_time.min) ' minutes'];
%% Theoretical BEM-MSE Calculation
if(DE_option.estimation_on == 1)
    [dv.Theory_BEM_MSE] = Theoretical_BEM_MSE(sys_par,fade_struct,snr,est_par,tx_par,rx_par,td_window,indv);
end
%% Save files
% filename of .mat
filename = "";
filename = filename + "data/";

switch(DE_option.type)
    case(1)
        filename = filename + "E-mode";
    case(2)
        filename = filename + "D-mode";
    case(3)
        filename = filename + "D&E-mode";
end

filename = filename + "_" + td_window.str(td_window.type);
if(td_window.type == 2)
    filename = filename + "_Q=" +num2str(td_window.Q);
end

if(DE_option.estimation_on == 1)
   filename = filename + "_" + est_par.BEM.str(est_par.BEM.type) + "_" + est_par.type_str(est_par.type);
end

if(DE_option.detection_on == 1)
    filename = filename + "_" + rx_par.type_str(rx_par.type);
    
    if(rx_par.type == 1||rx_par.type == 7)
        if(rx_par.IBDFE.first_iteration_full == 1)
            filename = filename + "_1st_full";
        end
    end
    if(rx_par.type == 5||rx_par.type == 6||rx_par.type == 7||rx_par.type == 8)
        filename = filename + "_D=" + num2str(rx_par.IBDFE.D);
    end
end

filename = filename + "_" + tx_par.mod_type_str(tx_par.mod_type);
filename = filename + "_fd=" + num2str(fade_struct.fd);
filename = filename + "_Nblock=" + num2str(tx_par.nblock);
filename = filename + ".mat";
save(filename,'indv','dv','sys_par','est_par','tx_par','rx_par','snr','fade_struct','td_window');
disp('------------------------------------------------');
figure(1)
semilogy(indv.range,dv.SER(1,:),'-d');
xlabel('SNR');
ylabel('BER');
grid on;
hold on;
semilogy(indv.range,dv.BER(2,:),'-^');
semilogy(indv.range,dv.BER(3,:),'-*');
semilogy(indv.range,dv.BER(4,:),'-o');
legend('1','2','3','4')
