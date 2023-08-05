%%Single Carrier System Adopting Basis Expansion Model
%%2022/5/6 by Yi Cheng Lin
%Assume signal power=1, channel total power = 1
%clc;
clear all;
tic; %timer
%% Options(Channel Estimation & Detection)
DE_option.estimation_on = 1;
DE_option.detection_on = 1;
DE_option.type = DE_option.estimation_on + DE_option.detection_on*2;
DE_option.plot_ber = 1;
%Type 0: Not Working
%Type 1: Estimation Mode(No Detection)
%Type 2: Detection Mode(Assume Perfect Channel Estimation, No Channel Estimation)
%Type 3: Channel Estimation And Detection Both Working
%% Time Domain Window parameter 時域視窗濾波器
td_window.str = ["No-windowing","MBAE-SOE","Tang"];
td_window.type = 3;
td_window.Q = 4;
%% System parameters(Frame structure)
sys_par.ts_type_str = {'Non-optiaml','Optiaml'};
sys_par.ts_type = 2;  % 1: Non-optiaml
                      % 2: Optiaml
sys_par.cpzp_type_str = {'CP','ZP'};    % Only use for Optimal pilot
sys_par.cpzp_type = 2;  % 1: CP
                      % 2: ZP
sys_par.equal_power = 0;    % 1: On

sys_par.tblock = 256; %Blocksize
sys_par.M = 5;%CP length + 1: M

sys_par.P = 14;%pilot cluster length: P+1, P is even
sys_par.G = 6;%cluster number: G
sys_par.nts = sys_par.G*(sys_par.P+1); %Number of total pilot symbols
sys_par.ndata = sys_par.tblock - sys_par.nts; % Number of data symbols
sys_par.bandwidth_efficiency = sys_par.ndata/sys_par.tblock*100;
sys_par.pilot_shift = 15;
sys_par.pilot_scheme = 1;

sys_par.pilot_random_seed = 0;
sys_par.random_seed = 0;
%% Channel parameters 通道參數
fade_struct.ch_length = sys_par.M;
fade_struct.fading_flag = 1;  
fade_struct.ch_model = 3; % 3: fast fading exponential PDP, 4:fast fading uniform PDP, for slow fading: set fd=0
fade_struct.nrms = 10;

fade_struct.fd = 0.5;% Doppler frequency
fade_struct.nor_fd = fade_struct.fd/sys_par.tblock;
%% SNR parameters(Noise) 雜訊
snr.db = 10;
snr.noise_pwr=10^(-snr.db/10);
%% Channel Estimator parameters(BEM) 通道估測
est_par.type_str = {'LS','BLUE','MMSE'};
est_par.type = 3;

est_par.BEM.str = ["CE-BEM","GCE-BEM","P-BEM"];
est_par.BEM.typenum = size(est_par.BEM.str,2);
est_par.BEM.type = 2;

if(fade_struct.fd>=0.1&&fade_struct.fd<=0.2)
    est_par.BEM.I = 5;
elseif(fade_struct.fd==0.02)
    est_par.BEM.I = 3;
else
    est_par.BEM.I = 9;
end

est_par.BEM.Q = floor(est_par.BEM.I/2);

est_par.l = 4;%parameter l determines the range of observation vector used for channel estimation(l>=0, l<=(P+M-1)/2 for SC system);
est_par.BLUE_iterative_times = 5;

est_par.plot_taps = 0;%plot the taps or not
est_par.plot_taps_blockindex = 1;

%% Optimal的參數設定
if(sys_par.ts_type==2) 
    sys_par.L = sys_par.M-1;
    est_par.l = sys_par.L;
    sys_par.P = 2*(sys_par.L);
    sys_par.G = est_par.BEM.I;
    sys_par.nts = sys_par.G*(sys_par.P+1); %Number of total pilot symbols
    sys_par.ndata = sys_par.tblock - sys_par.nts; % Number of data symbols
    if(sys_par.cpzp_type==2)
        if(mod(sys_par.ndata,sys_par.G)~=0)
            sys_par.ndata = sys_par.G*floor(sys_par.ndata/sys_par.G);
            sys_par.nts = sys_par.tblock-sys_par.ndata;
        end
    end
    sys_par.bandwidth_efficiency = sys_par.ndata/sys_par.tblock*100;
end

%% Tx parameters 傳送端參數
tx_par.mod_type_str={'BPSK','QPSK','16QAM','64QAM'};
tx_par.mod_type = 2; % 1: BPSK
                     % 2: QPSK
                     % 3: 16QAM
                   
tx_par.mod_nbits_per_sym = [1 2 4 6]; % bit of mod type
tx_par.nbits_per_sym = tx_par.mod_nbits_per_sym(tx_par.mod_type);
tx_par.pts_mod_const=2^(tx_par.nbits_per_sym); % points in modulation constellation

tx_par.nblock= 10000; % Number of transmitted blocks
%% Train parameters 訓練符元參數
ts_par.mod_type_str={'BPSK','QPSK','16QAM','64QAM'};
ts_par.mod_type = 1; % 1: BPSK
                     % 2: QPSK
                     % 3: 16QAM
                   
ts_par.mod_nbits_per_sym = [1 2 4 6]; % bit of mod type
ts_par.nbits_per_sym = ts_par.mod_nbits_per_sym(ts_par.mod_type);
ts_par.pts_mod_const=2^(ts_par.nbits_per_sym); % points in modulation constellation


%% Rx parameter 接收端參數
% IBDFE (Scaling Factor removed and divide beta before slicing)
rx_par.type_str={
    'IBDFE_TI';   % 1
    'IBDFE_TV';   % 2
    'MMSE_FD_LE'
    };
rx_par.type = 2;

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

rx_par.IBDFE.first_iteration_banded = 1;  % 1: IBDFE-TV 1st using Banded-MMSE-LE , 0: Full-MMSE-LE (usless on IBDFE-TI)
rx_par.IBDFE.frist_banded_Q = 4;

rx_par.IBDFE.D_FF_Full = 0; % 1: Full matrix FF Filter
rx_par.IBDFE.D_FB_Full = 0; % 1: Full matrix FB Filter
rx_par.IBDFE.D_FF = 1;
rx_par.IBDFE.D_FB = 2;  

td_window.Q = rx_par.IBDFE.frist_banded_Q*2;
%Parameter for iterative equalizer;
rx_par.iteration = 3;



if(rx_par.type==3)
    rx_par.iteration = 1;
end
error_message(td_window,sys_par,fade_struct,tx_par,ts_par,rx_par)
%% Independent variable 控制變因
indv.str = ["SNR","fd"];
indv.option = 1;
indv.range = 0:4:24;
%% Dependent variable 應變變因
%BER,SER

dv.BER_ideal = zeros(rx_par.iteration,size(indv.range,2));
dv.SER_ideal = zeros(rx_par.iteration,size(indv.range,2));
if(DE_option.estimation_on == 1)
    dv.BER_est = zeros(rx_par.iteration,size(indv.range,2));
    dv.SER_est = zeros(rx_par.iteration,size(indv.range,2));
end


%MSE
dv.BEM_MSE = zeros(1,size(indv.range,2));
dv.CH_MSE = zeros(1,size(indv.range,2));
dv.CH_banded_approx = zeros(1,size(indv.range,2));
dv.Theory_BEM_MSE = zeros(1,size(indv.range,2));

%% get filename
[filename, filename2] = Get_filename(DE_option,td_window,sys_par,fade_struct,est_par,tx_par,rx_par,indv,dv,snr);
filename

%% Banded Mask initialization
if(rx_par.IBDFE.first_iteration_banded==1)    % 1st Banded
    rx_par.B_mtx = zeros(sys_par.tblock,sys_par.tblock);
    rx_par.B_mtx2 = zeros(sys_par.tblock,sys_par.tblock);
    for k=0:sys_par.tblock-1
        rho = mod(k-rx_par.IBDFE.frist_banded_Q-1+(1:rx_par.IBDFE.frist_banded_Q*2+1),sys_par.tblock)+1;
        rx_par.B_mtx(rho,k+1) = 1;
    end
    rx_par.B_mtx2(rx_par.B_mtx*rx_par.B_mtx~=0)=1;
else
    rx_par.B_mtx = ones(sys_par.tblock,sys_par.tblock);
    rx_par.B_mtx2 = ones(sys_par.tblock,sys_par.tblock);
end
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
    end
    
    %initialization
    switch(sys_par.ts_type)
        case(1) % Non-optimal
            [pilot,data,observation,contaminating_data,w,U,A,Rc] = SC_system_initialization(sys_par,tx_par,ts_par,est_par,td_window,fade_struct);
        case(2) % Optimal
            [pilot,data,observation,contaminating_data,w,U,A,Rc] = SC_system_initialization_Op(sys_par,tx_par,ts_par,est_par,td_window,fade_struct);
    end
    
    % Noise power will change if we use window ???
    
    %Set random seed
    rand('state',sys_par.random_seed);
    randn('state',sys_par.random_seed);
    dv.bit_error_count_id = zeros(size(dv.BER_ideal,1),1);
    dv.sym_error_count_id = zeros(size(dv.SER_ideal,1),1);
    if(DE_option.estimation_on == 1)
        dv.bit_error_count_est = zeros(size(dv.BER_est,1),1);
        dv.sym_error_count_est = zeros(size(dv.SER_est,1),1);
    end
    dv.BEM_MSE_count = 0;
    dv.CH_MSE_count = 0;
    
    
    re = zeros(sys_par.tblock,sys_par.tblock);
    for ii=1:tx_par.nblock
        
        %display(indv.str(indv.option)+' & block index  '+num2str(indv.range(kk))+'_'+num2str(ii));
        
        [data.const_data, data.dec_data, data.bit_data]=block_sym_mapping(sys_par.ndata,tx_par,ts_par,1);% generate data block
        trans_block = zeros(1,sys_par.tblock);
        trans_block(reshape(pilot.position.',1,[])) = reshape(pilot.clusters_symbol.',1,[]);
        trans_block(data.position) = data.const_data*sqrt(data.power);
        trans_block = trans_block.';%column vector
        
        noise_block=sqrt(snr.noise_pwr/2)*(randn(1,sys_par.tblock)+1j*randn(1,sys_par.tblock));
        noise_block = noise_block.';%column vector
        
        [h,h_taps,h_avg_pwr] = gen_ch_imp(fade_struct, sys_par,ii);
        
        y = h*trans_block + noise_block;
        
        %Channel Estimation...
        if(DE_option.estimation_on == 1)
            
            y_O = y(reshape(observation.position.',1,[]));
            
            switch(est_par.type)
                case(1)%LS
                    [h_est, h_taps_est, c_est] = Estimator_LS(sys_par,A,y_O,U);
                case(2)%Iterative BLUE
                    [h_est, h_taps_est, c_est] = Estimator_Iterative_BLUE(sys_par,A,y_O,snr.noise_pwr,observation,contaminating_data,est_par,U,w);
                case(3)%MMSE
                    [h_est, h_taps_est, c_est] = Estimator_MMSE(sys_par,A,y_O,snr.noise_pwr,observation,est_par,U,w,h_avg_pwr,Rc);
            end

            dv.CH_MSE_count = dv.CH_MSE_count + trace((h_taps_est - h_taps)*(h_taps_est - h_taps)');
            
            [h_approx,h_taps_approx,c] = BEM_approximation(h, fade_struct.ch_length, est_par.BEM.Q,est_par.BEM.type,w,est_par);
            dv.BEM_MSE_count = dv.BEM_MSE_count + trace((c_est - c)*(c_est-c)');
            
            %plot taps
            if(est_par.plot_taps == 1 && ii == est_par.plot_taps_blockindex)
                plot_BEM_estimated_channel(sys_par,h_taps,h_taps_est,h_taps_approx);
                sgtitle(est_par.BEM.str(est_par.BEM.type) + " by " + est_par.type_str(est_par.type) + " Estimator ( fd = " + num2str(fade_struct.fd) + ", SNR = "+ num2str(snr.db) + " )");
            end
        end
        
        %Detection...
        if(DE_option.detection_on ==1)     
            
            switch(rx_par.type)  
                case(1) %IBDFE_TI
                    if(DE_option.estimation_on == 1)
                        [data.hat_dec2, data.hat_bit2] = IBDFE_TI(sys_par,tx_par,ts_par,rx_par,h_est,y,snr.noise_pwr,pilot,data);
                    end
                    [data.hat_dec, data.hat_bit] = IBDFE_TI(sys_par,tx_par,ts_par,rx_par,h,y,snr.noise_pwr,pilot,data);
                case(2)
                    if(DE_option.estimation_on == 1)    % IBDFE_TV
                        [data.hat_dec2, data.hat_bit2]=IBDFE_TV(sys_par,tx_par,ts_par,rx_par,h_est,y,snr.noise_pwr,pilot,data,w);
                    end
                    [data.hat_dec, data.hat_bit]=IBDFE_TV(sys_par,tx_par,ts_par,rx_par,h,y,snr.noise_pwr,pilot,data,w);
                case(3)
                    if(DE_option.estimation_on == 1)    % MMSE_FD_LE
                        [data.hat_dec2, data.hat_bit2]=IBDFE_TV(sys_par,tx_par,ts_par,rx_par,h_est,y,snr.noise_pwr,pilot,data,w);
                    end
                    [data.hat_dec, data.hat_bit]=IBDFE_TV(sys_par,tx_par,ts_par,rx_par,h,y,snr.noise_pwr,pilot,data,w);  
            end% end rx_par.type

            dv.sym_error_count_id(:,1) = dv.sym_error_count_id(:,1) + sum((data.hat_dec-data.dec_data)~=0,2);
            dv.bit_error_count_id(:,1) = dv.bit_error_count_id(:,1) + sum((data.hat_bit-data.bit_data)~=0,2);
            if(DE_option.estimation_on == 1)
                dv.sym_error_count_est(:,1) = dv.sym_error_count_est(:,1) + sum((data.hat_dec2-data.dec_data)~=0,2);
                dv.bit_error_count_est(:,1) = dv.bit_error_count_est(:,1) + sum((data.hat_bit2-data.bit_data)~=0,2);
            end   
        end
    end % end ii=1:tx_par.nblock
    
    dv.SER_ideal(:,kk) = dv.sym_error_count_id/(tx_par.nblock*sys_par.ndata);
    dv.BER_ideal(:,kk) = dv.bit_error_count_id/(tx_par.nblock*sys_par.ndata*tx_par.nbits_per_sym);
    if(DE_option.estimation_on == 1)
        dv.SER_est(:,kk) = dv.sym_error_count_est/(tx_par.nblock*sys_par.ndata);
        dv.BER_est(:,kk) = dv.bit_error_count_est/(tx_par.nblock*sys_par.ndata*tx_par.nbits_per_sym);
    end
    
    dv.BEM_MSE(1,kk) = dv.BEM_MSE_count/tx_par.nblock;
    dv.CH_MSE(1,kk) = dv.CH_MSE_count/tx_par.nblock;
end% end kk = 1:size(indv.range,2);
% execution time
run_time.total=fix(toc/60); % unit: minute
run_time.hour=fix(run_time.total/60);
run_time.min=run_time.total-run_time.hour*60;
dv.run_time_str=[num2str(run_time.hour) ' hours and ' num2str(run_time.min) ' minutes'];
%% Theoretical BEM-MSE Calculation
%if(DE_option.estimation_on == 1)
%    [dv.Theory_BEM_MSE] = Theoretical_BEM_MSE(sys_par,fade_struct,snr,est_par,tx_par,rx_par,td_window,indv);
%end
%% Save files
save(filename,'indv','dv','sys_par','est_par','tx_par','rx_par','snr','fade_struct','td_window','pilot');
disp('------------------------------------------------');
if(DE_option.plot_ber==1)
    figure(100)
    if(DE_option.estimation_on == 1)
        semilogy(indv.range,dv.BER_est(end,:),'->');
        grid on;
        hold on;
        %semilogy(indv.range,dv.BER_ideal(end,:),'--d');
        %legend('Est','Ideal')
    else
        %semilogy(indv.range,dv.BER_ideal(end,:),'--d');
        legend('Ideal')
    end
    
    if(indv.option==1)
        xlabel('SNR');
    else
        xlabel('fd');
    end
    ylabel('BER');
    %title(filename2)
end
